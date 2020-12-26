//
//  MiniGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MiniGraphView

struct MiniGraphView: View {
    @Environment(\.lineChartStyle) var lineChartStyle
    @EnvironmentObject var viewRouter: ViewRouter
    var viewLogic = MiniGraphViewLogic()

    let entries: [Entry]
    let dataPoints: [CGFloat]
    let onEntrySelected: (Int) -> Void

    @State private var selectedIdx = Int()
    @State private var idxShift = Int()
    @State private var newIdx = Int()

    @State private var selectionLineOn = false
    @State private var lineGraphBottomPadding: CGFloat = 0

    // LineGraphView
    @State private var offset: CGFloat = UIScreen.screenWidth
    @State private var layout = [GridItem]()
    @State private var lineFrameSpacing: CGFloat = .zero

    var body: some View {
        ZStack {
            lineGraphData

            GeometryReader { geo in

                LazyVGrid(columns: layout, alignment: .center) {
                    ForEach(self.entries.indexed(), id: \.1.self) { idx, entry in
                        GraphLine(
                            idx: idx,
                            newIdx: self.newIdx,
                            selectedIdx: self.selectedIdx,
                            entry: entry,
                            dateLabelPadding: self.lineChartStyle.dateLabelPadding,
                            onDateLabelHeightChange: self.updateLineGraphBottomPadding
                        )
                        .frame(width: lineChartStyle.lineFrameWidth, height: geo.h)
                        .tappable()
                        .onTapGesture {
                            self.changeSelection(idx)
                        }
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(
                                preferences: preferences,
                                width: self.lineChartStyle.selectionLineWidth
                            )
                            .opacity(self.selectionLineOn ? 1 : 0)
                            .draggableSelection(lines: self.entries.count,
                                                lineFrameWidth: lineChartStyle.lineFrameWidth,
                                                lineFrameSpacing: self.lineFrameSpacing,
                                                selectedIdx: self.selectedIdx,
                                                onDragChanged: self.changeNewIdx(to:),
                                                onDragEnded: self.changeSelectedIdx(to:)
                            )
                        })
                        .onAppear(perform: self.showSelectionLine)
                    }
                }
                // This is a temp fix for the LazyVGrid
                // to transition on with the view transition.
                .offset(x: self.offset)
                .onAppear {
                    // IMPORTANT:
                    // This calculation needs to happen before the animation.
                    self.updateLineFrameSpacing(for: geo)

                    withSpringAnimation { self.offset = 0 }
                }
            }
        }
        .onAppear(perform: self.resetToDefaultSelection)
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
    }
}

// MARK: - Internal Methods

extension MiniGraphView {

    private func updateLayout(_ layout: [GridItem]) {
        self.layout = layout
    }

    private func updateLineFrameSpacing(for geo: GeometryProxy) {
        self.lineFrameSpacing = self.viewLogic.lineFrameSpacing(geo: geo,
                                                                numOfLines: self.entries.count,
                                                           lineWidth: lineChartStyle.lineFrameWidth,
                                                           completion: self.updateLayout(_:))
    }

    /// Always reset selection to current day
    private func resetToDefaultSelection() {
        let idx = self.entries.count - 1
        self.changeSelectedIdx(to: idx)
    }

    private func showSelectionLine() {
        withAnimation(lineChartStyle.selectionLineAnimation) {
            self.selectionLineOn = self.viewRouter.isJournal
        }
    }

    private func updateLineGraphBottomPadding(_ padding: CGFloat) {
        self.lineGraphBottomPadding = padding
    }

    private func changeSelection(_ idx: Int) {
        self.changeNewIdx(to: idx)
        self.changeSelectedIdx(to: idx)
    }

    private func changeNewIdx(to idx: Int) {
        self.newIdx = idx
    }

    private func changeSelectedIdx(to idx: Int) {
        self.selectedIdx = idx
        self.onEntrySelected(idx)
    }
}

// MARK: - Internal Views

extension MiniGraphView {
    private var lineGraphData: some View {
        LineGraphData(dataPoints: self.dataPoints)
            .padding(EdgeInsets(top: 0,
                                leading: 12,
                                bottom: self.lineGraphBottomPadding,
                                trailing: 12))
            // Set to false so gestures can work
            .allowsHitTesting(false)
    }
}

// MARK: - Views

struct GraphLine: View {
    let idx: Int
    let newIdx: Int
    let selectedIdx: Int
    let entry: Entry
    let dateLabelPadding: CGFloat
    let onDateLabelHeightChange: (CGFloat) -> Void

    @State private var on = false

    private var selectionSnappedToIdx: Bool {
        return newIdx == idx
    }

    var body: some View {
        VStack(spacing: dateLabelPadding) {
            line
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
            dateLabel
                // Track the  height of the date label and calculate the correct bottom padding
                // needed for the line graph to stay within bounds.
                // This happens once for every date (7), but this behaviour is expected
                // as the sizes are saved into an array.
                .coordinateSpace(name: "dateLabel")
                .saveSizes(viewID: 1, coordinateSpace: .named("dateLabel"))
                .retrieveSizes(viewID: 1) {
                    self.onDateLabelHeightChange($0.height + dateLabelPadding)
                }
        }
        .tappable()
    }

    private var line: some View {
        Rectangle()
            .foregroundColor(.clear).frame(width: 1)
            .background(
                LinearGradient(.graphLineGradient, direction: .vertical)
            )
    }

    private var dateLabel: some View {
        VStack(spacing: dateLabelPadding) {
            Text("\(self.entry.date.weekday)")
                .msk_applyTextStyle(.graphWeekdayDetailFont)
            Text("\(self.entry.date.day)")
                .msk_applyTextStyle(.graphDayDetailFont)
        }
    }
}

// MARK: - SelectionLine

struct SelectionLine: View {
    let preferences: Anchor<CGRect>?
    let width: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            preferences.map {
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(Color.momo)
                    .frame(width: width, height: geo[$0].height)
                    .frame(width: geo.w,
                           height: geo[$0].height,
                           alignment: .center
                    )
                    .msk_applyDropShadow()
            }
        }
    }
}
