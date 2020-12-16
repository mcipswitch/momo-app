//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

// https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f

import SwiftUI

// MARK: - JournalGraphViewLogic

struct GraphViewLogic {
    var columnLayout: (CGFloat, Int) -> [GridItem] = { (spacing, count) -> [GridItem] in
        Array(
            repeating: .init(.flexible(), spacing: spacing),
            count: count)
    }
}

// MARK: - MiniGraphView

struct MiniGraphView: View {
    typealias Graph = MSK.Journal.Graph

    @EnvironmentObject var viewRouter: ViewRouter
    var viewLogic = GraphViewLogic()

    let entries: [Entry]
    let dataPoints: [CGFloat]
    let onEntrySelected: (Int) -> Void

    /// Default selection is current day
    @State private var selectedIdx: Int = 6
    @State private var idxShift: Int = 0
    @State private var newIdx: Int = 6

    @State private var selectionLineOpacity = false
    @State private var lineGraphBottomPadding: CGFloat = 0

    @State private var offset: CGFloat = UIScreen.screenWidth
    
    // MARK: - Body

    var body: some View {
        ZStack {
            LineGraphView(dataPoints: self.dataPoints)
                .padding(EdgeInsets(top: 0,
                                    leading: 12,
                                    bottom: self.lineGraphBottomPadding,
                                    trailing: 12))
                .allowsHitTesting(false)

            GeometryReader { geo in

                // Calculate the spacing between graph lines
                let numOfItems: CGFloat = self.entries.count.floatValue
                let numOfSpaces: CGFloat = numOfItems - 1
                let itemWidth: CGFloat = 25
                let totalItemWidth: CGFloat = itemWidth * numOfItems
                let itemFrameSpacing: CGFloat = (geo.size.width - totalItemWidth) / numOfSpaces
                let itemSpacing: CGFloat = itemWidth + itemFrameSpacing

                //                let columnLayout: [GridItem] = Array(
                //                    repeating: .init(.flexible(), spacing: itemFrameSpacing),
                //                    count: self.entries.count)

                let columnLayout = viewLogic.columnLayout(itemFrameSpacing, entries.count)

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< self.entries.count) { idx in
                        GraphLine(
                            spacing: Graph.spacing,
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
                                width: Graph.selectionLineWidth
                            )
                            .opacity(self.selectionLineOpacity ? 1 : 0)
                            .modifier(
                                SelectionLineModifier(items: entries.count,
                                                      itemWidth: itemWidth,
                                                      itemSpacing: itemSpacing,
                                                      selectedIdx: selectedIdx,
                                                      onDragEnded: changeSelectedIdx(to:))
                            )
                        })
                        .onReceive(self.viewRouter.objectWillChange, perform: {

                            // Animate SelectionLine after line graph animates in
                            withAnimation(self.viewRouter.isHome
                                            ? Animation.linear.delay(0.2)
                                            : Animation.easeInOut(duration: 0.8).delay(1.8)) {
                                self.selectionLineOpacity.toggle()
                            }

                        })
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
                VStack {
                    Text("IDX: \(self.selectedIdx)")
                }
            }
        }
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
    }

    // MARK: - Internal Methods

    private func updateLineGraphBottomPadding(_ padding: CGFloat) {
        self.lineGraphBottomPadding = padding
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
                 There is a bug that shows the selection line behind the graph line.
                 This is a temporary fix that hides the line if it is selected.
                 */
                .opacity(on ? (newIdx == idx ? 0 : 1) : 1)
                .onChange(of: newIdx) { idx in
                    self.on = true
                }
            dateLabel
                /*
                 Track the height of the date label and calculate the correct
                 bottom padding needed for the graph line to stay within bounds.
                 */
                .attachSizeModifier()
                .onPreferenceChange(SizePreferenceKey.self) {
                    self.onDateLabelHeightChange($0.height + spacing)
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
                .msk_applyStyle(.graphWeekdayDetailFont)
            Text("\(self.entries[idx].date.day)")
                .msk_applyStyle(.graphDayDetailFont)
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
