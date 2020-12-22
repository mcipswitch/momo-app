//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

// https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f

import SwiftUI

// MARK: - MiniGraphView

struct MiniGraphView: View {
    @Environment(\.lineChartStyle) var lineChartStyle
    @EnvironmentObject var viewRouter: ViewRouter
    let entries: [Entry]
    let dataPoints: [CGFloat]
    let onEntrySelected: (Int) -> Void

    @State private var selectedIdx = Int()
    @State private var idxShift = Int()
    @State private var newIdx = Int()

    @State private var selectionLineOn = false
    @State private var lineGraphBottomPadding: CGFloat = 0

    @State private var offset: CGFloat = UIScreen.screenWidth

    var body: some View {
        ZStack {
            LineGraphView(dataPoints: self.dataPoints)
                .padding(EdgeInsets(top: 0,
                                    leading: 12,
                                    bottom: self.lineGraphBottomPadding,
                                    trailing: 12))
                .allowsHitTesting(false)

            GeometryReader { geo in

                // TODO: - simplify all this code
                let numOfItems: CGFloat = self.entries.count.floatValue
                let itemWidth: CGFloat = 25
                let totalItemWidth: CGFloat = itemWidth * numOfItems
                let itemFrameSpacing: CGFloat = (geo.size.width - totalItemWidth) / (numOfItems - 1)
                let itemSpacing: CGFloat = itemWidth + itemFrameSpacing

                let columnLayout = lineChartStyle.columnLayout(itemFrameSpacing, entries.count)

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< self.entries.count) { idx in
                        GraphLine(
                            spacing: lineChartStyle.labelPadding,
                            selectedIdx: self.selectedIdx,
                            newIdx: self.newIdx,
                            idx: idx,
                            entries: self.entries,
                            onDateLabelHeightChange: self.updateLineGraphBottomPadding
                        )
                        .frame(minWidth: itemWidth, idealHeight: geo.size.height, maxHeight: geo.size.height)
                        .onTapGesture {
                            self.newIdx = idx
                            self.changeSelectedIdx(to: self.newIdx)
                        }
                        .contentShape(Rectangle())
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(
                                preferences: preferences,
                                width: lineChartStyle.selectionLineWidth
                            )
                            .opacity(selectionLineOn ? 1 : 0)
                            .modifier(
                                SelectionLineModifier(items: entries.count,
                                                      itemWidth: itemWidth,
                                                      itemSpacing: itemSpacing,
                                                      selectedIdx: selectedIdx,
                                                      onDragChanged: changeNewIdx(to:),
                                                      onDragEnded: changeSelectedIdx(to:))
                            )
                        })
                        .onAppear(perform: showSelectionLine)
                    }
                }
                // IMPORTANT:
                // This is a temporary fix for the LazyVGrid
                // not transitioning on with a slide animation.
                .offset(x: offset)
                .onAppear {
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
                // TODO


                VStack {
                    Text("IDX: \(self.selectedIdx)")
                }
            }
        }
        .onAppear(perform: resetToDefaultSelection)
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
    }

    // MARK: - Internal Methods

    private func resetToDefaultSelection() {
        let idx = entries.count - 1
        self.changeSelectedIdx(to: idx)
    }

    private func showSelectionLine() {
        if viewRouter.isJournal {
            withAnimation(lineChartStyle.selectionLineAnimation) {
                selectionLineOn = viewRouter.isJournal
            }
        }
    }

    private func updateLineGraphBottomPadding(_ padding: CGFloat) {
        self.lineGraphBottomPadding = padding
    }

    private func changeNewIdx(to idx: Int) {
        self.newIdx = idx
    }

    private func changeSelectedIdx(to idx: Int) {
        self.selectedIdx = idx
        self.onEntrySelected(idx)
    }
}

// MARK: - Views

struct GraphLine: View {
    let spacing: CGFloat
    let selectedIdx: Int
    let newIdx: Int
    let idx: Int
    let entries: [Entry]
    let onDateLabelHeightChange: (CGFloat) -> Void

    @State private var on = false

    private var selectionSnappedToIdx: Bool {
        return newIdx == idx
    }

    var body: some View {
        VStack(spacing: spacing) {
            line
                .anchorPreference(
                    key: SelectionPreferenceKey.self,
                    value: .bounds,
                    transform: { anchor in
                        self.selectedIdx == idx ? anchor : nil
                    })
                /*
                 TODO:
                 There is a bug that shows the selection line behind the graph line.
                 This is a temporary fix that hides the line if it is selected.
                 */
                .opacity(on ? (selectionSnappedToIdx ? 0 : 1) : 1)
                .onChange(of: newIdx) { _ in
                    self.on = true
                }
            dateLabel
                // Track the height of the date label and calculate the correct
                // bottom padding needed for the graph line to stay within bounds.
                // TODO: - This is happening 7 times, once for each date
                .saveSizes(viewID: 1)
                .retrieveSizes(viewID: 1) { bounds in
                    self.onDateLabelHeightChange(bounds.height + spacing)
                }
        }
        // Make whole stack tappable
        .contentShape(Rectangle())
    }

    private var line: some View {
        Rectangle()
            .foregroundColor(.clear).frame(width: 1)
            .background(graphLineGradient)
    }

    private var graphLineGradient: some View {
        LinearGradient(gradient: .graphLineGradient,
                       startPoint: .bottom,
                       endPoint: .top)
    }

    private var dateLabel: some View {
        VStack(spacing: spacing) {
            Text("\(self.entries[idx].date.weekday)")
                .msk_applyTextStyle(.graphWeekdayDetailFont)
            Text("\(self.entries[idx].date.day)")
                .msk_applyTextStyle(.graphDayDetailFont)
        }
    }
}

// MARK: - SelectionLine

// TODO: - refactor pref key

struct SelectionLine: View {
    let preferences: Anchor<CGRect>?
    let width: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            preferences.map {
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(Color.momo)
                    .frame(width: width, height: geo[$0].height)
                    .frame(
                        width: geo.size.width,
                        height: geo[$0].height,
                        alignment: .center
                    )
                    .msk_applyDropShadow()
            }
        }
    }
}

// MARK: - Preference Keys

struct SelectionPreferenceKey: PreferenceKey {
    static var defaultValue: Value = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
