//
//  MiniGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI
import ComposableArchitecture

struct MiniChartView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @Environment(\.lineChartStyle) var lineChartStyle
    @State private var selectedIdx = Int()
    @State private var newIdx = Int()
    @State private var lineGraphBottomPadding: CGFloat = 0
    @State private var layout = [GridItem]()
    @State private var lineFrameSpacing: CGFloat = .zero
    var viewLogic = MiniGraphViewLogic()

    var body: some View {
        ZStack {
            LineGraphData(viewStore: self.viewStore,
                          dataPoints: self.viewStore.dataPoints)
                .padding(EdgeInsets(top: 0,
                                    leading: .momo(.scale3),
                                    bottom: self.lineGraphBottomPadding,
                                    trailing: .momo(.scale3)))
                .allowsHitTesting(false)

            GeometryReader { geo in
                LazyVGrid(columns: self.layout, alignment: .center) {
                    ForEach(self.viewStore.journalEntries.indexed(), id: \.1.self) { idx, entry in
                        GraphLine(
                            idx: idx,
                            newIdx: self.newIdx,
                            selectedIdx: self.selectedIdx,
                            entry: entry,
                            onDateLabelHeightChange: self.updateLineGraphBottomPadding
                        )
                        .frame(width: self.lineChartStyle.lineFrameWidth, height: geo.h)
                        .overlayPreferenceValue(SelectionPreferenceKey.self) { preferences in
                            SelectionLine(preferences: preferences)
                                .opacity(self.viewStore.selectionLineAnimationOn ? 1 : 0)
                                .draggableSelection(
                                    lines: self.viewStore.journalEntries.count,
                                    lineFrameWidth: self.lineChartStyle.lineFrameWidth,
                                    lineFrameSpacing: self.lineFrameSpacing,
                                    selectedIdx: self.selectedIdx,
                                    onDragChanged: self.changeNewIdx(to:),
                                    onDragEnded: self.changeSelectedIdx(to:)
                                )
                        }
                        .onTapGesture {
                            self.changeSelectedIdx(to: idx)
                        }
                    }
                }
                .onAppear {
                    self.updateLineFrameSpacing(for: geo)
                }
            }
        }
        .onAppear {
            // Always reset selection to current day
            self.changeSelectedIdx(to: self.viewStore.numOfEntries - 1)
        }
        .padding(
            EdgeInsets(top: .momo(.scale4),
                       leading: .momo(.scale2),
                       bottom: .momo(.scale4),
                       trailing: .momo(.scale2))
        )
    }
}

// MARK: - Internal Methods

extension MiniChartView {
    private func updateLineFrameSpacing(for geo: GeometryProxy) {
        self.lineFrameSpacing = self.viewLogic.lineFrameSpacing(
            geo: geo,
            numOfLines: self.viewStore.journalEntries.count,
            lineWidth: lineChartStyle.lineFrameWidth,
            completion: self.updateLayout)
    }

    private func updateLayout(_ layout: [GridItem]) {
        self.layout = layout
    }

    /// This adds padding to the line graph data
    /// so that it sits correctly on the x-axis.
    private func updateLineGraphBottomPadding(_ padding: CGFloat) {
        self.lineGraphBottomPadding = padding
    }

    private func changeNewIdx(to idx: Int) {
        self.newIdx = idx
        self.viewStore.send(.form(.set(\.selectedEntry, self.viewStore.journalEntries[idx])))
    }

    private func changeSelectedIdx(to idx: Int) {
        self.newIdx = idx
        self.selectedIdx = idx
        self.viewStore.send(.form(.set(\.selectedEntry, self.viewStore.journalEntries[idx])))
    }
}

// MARK: - Views

struct GraphLine: View {
    let idx: Int
    let newIdx: Int
    let selectedIdx: Int
    let entry: Entry
    let onDateLabelHeightChange: (CGFloat) -> Void
    @State private var on = false

    private var selectionSnappedToIdx: Bool {
        return newIdx == idx
    }

    var body: some View {
        VStack(spacing: .momo(.scale2)) {
                LinearGradient(.momo(.lineGraph), direction: .vertical)
                    .frame(width: 1)
                    .anchorPreference(
                        key: SelectionPreferenceKey.self,
                        value: .bounds,
                        transform: { anchor in
                            self.selectedIdx == idx ? anchor : nil
                        })
                    // There is a bug that shows the selection line behind the graph line.
                    // This is a temp fix that hides the line if it is selected.
                    .opacity(on ? (selectionSnappedToIdx ? 0 : 1) : 1)
                    .onChange(of: newIdx) { _ in
                        self.on = true
                    }
            VStack(spacing: .momo(.scale2)) {
                    Text("\(self.entry.date.weekday)")
                        .momoText(.graphWeekdayDetailFont)
                    Text("\(self.entry.date.day)")
                        .momoText(.graphDayDetailFont)
                }
                 // Track the  height of the date label and calculate the correct bottom padding
                 // needed for the line graph to stay within bounds.
                 // This happens once for every date, but this behaviour is expected
                 // as the sizes are saved into an array.
                .coordinateSpace(name: "dateLabel")
                .saveSizes(viewID: 1, coordinateSpace: .named("dateLabel"))
                .retrieveSizes(viewID: 1) {
                    self.onDateLabelHeightChange($0.height + .momo(.scale2))
                }
            }
            .tappable()
    }
}

// MARK: - SelectionLine

struct SelectionLine: View {
    @Environment(\.lineChartStyle) var lineChartStyle
    let preferences: Anchor<CGRect>?
    
    var body: some View {
        GeometryReader { geo in
            preferences.map {
                RoundedRectangle(cornerRadius: self.lineChartStyle.selectionLineWidth / 2)
                    .fill(Color.momo)
                    .frame(width: self.lineChartStyle.selectionLineWidth,
                           height: geo[$0].height
                    )
                    .frame(width: geo.w,
                           height: geo[$0].height,
                           alignment: .center
                    )
                    .dropShadow()
            }
        }
    }
}
