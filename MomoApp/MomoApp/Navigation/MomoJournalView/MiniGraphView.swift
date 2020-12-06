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
    @EnvironmentObject var viewRouter: ViewRouter

    let entries: [Entry]
    let dataPoints: [CGFloat]
    let onEntrySelected: (Int) -> Void

    /// Default selection is current day
    @State private var selectedIdx: Int = 6
    @State private var idxShift: Int = 0
    @State private var newIdx: Int = 6

    // Selection Line
    @GestureState private var dragState: DragState = .inactive
    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var value: CGFloat = 0.5
    @State private var opacity = false

    @State private var lineGraphBottomPadding: CGFloat = 0
    
    // MARK: - Body

    var body: some View {
        ZStack {
            GeometryReader { geo in

                // Calculate the spacing between graph lines
                let numOfItems: CGFloat = self.entries.count.floatValue
                let numOfSpaces: CGFloat = numOfItems - 1
                let itemWidth: CGFloat = 25
                let totalItemWidth: CGFloat = itemWidth * numOfItems
                let itemFrameSpacing: CGFloat = (geo.size.width - totalItemWidth) / numOfSpaces
                let itemSpacing: CGFloat = itemWidth + itemFrameSpacing
                let columnLayout: [GridItem] = Array(
                    repeating: .init(.flexible(), spacing: itemFrameSpacing),
                    count: self.entries.count)

                // Drag Gesture
                let dragGesture = DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Calculate the index shift to the closest entry
                        self.idxShift = Int(round(value.translation.width / itemSpacing))
                        let newOffset = itemSpacing * CGFloat(idxShift)
                        self.dragOffset = newOffset

                        // Protect from scrolling out of bounds
                        self.newIdx = self.selectedIdx + self.idxShift
                        self.newIdx = max(0, self.newIdx)
                        self.newIdx = min(self.entries.count - 1, self.newIdx)
                    }
                    .updating($dragState) { value, state, transaction in
                        state = .active(location: value.location, translation: value.translation)
                        //transaction.animation = Animation.resist()
                    }
                    .onEnded { value in
                        self.dragOffset = .zero
                        self.changeSelectedIdx(to: self.newIdx)
                    }

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< self.entries.count) { idx in
                        GraphLine(
                            idxSelection: self.selectedIdx,
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

                        // This is needed to make whole stack tappable
                        .contentShape(Rectangle())
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(preferences: preferences)
                                .opacity(self.opacity ? 1 : 0)
                                .offset(x: self.dragOffset)
                                .gesture(dragGesture)
                        })
                        .onReceive(self.viewRouter.objectWillChange, perform: {
                            // Animate in selection line after graph line aniamtes in
                            withAnimation(self.viewRouter.isHome
                                            ? Animation.linear.delay(0.2)
                                            : Animation.easeInOut(duration: 0.8).delay(1.8)) {
                                self.opacity.toggle()
                            }
                        })
                    }
                }
                LineGraphView(dataPoints: self.dataPoints)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: self.lineGraphBottomPadding, trailing: 12))
                    .allowsHitTesting(false)

                VStack {
                    Text("IDX Selection: \(self.selectedIdx)")
                    Text("Drag: \(self.dragOffset)")
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
    let idxSelection: Int
    let newIdx: Int
    let idx: Int
    let entries: [Entry]
    let onDateLabelHeightChange: (CGFloat) -> Void

    @State private var on = false

    var body: some View {
        VStack(spacing: 8) {
            line
                .anchorPreference(
                    key: SelectionPreferenceKey.self,
                    value: .bounds,
                    transform: { anchor in
                        self.idxSelection == idx ? anchor : nil
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
                 Track the height of the date label
                 in order to calculate the correct bottom padding
                 needed for the graph line.
                 */
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) {
                    self.onDateLabelHeightChange($0.height + 8)
                }
        }
        // This is needed to make whole stack tappable
        .contentShape(Rectangle())
    }

    var line: some View {
        Rectangle()
            .foregroundColor(.clear).frame(width: 1)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.4),
                        Color.gray.opacity(0)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top)
            )
    }

    var dateLabel: some View {
        VStack(spacing: 8) {
            Text("\(self.entries[idx].date.weekday)")
                .momoText(.graphWeekday)
            Text("\(self.entries[idx].date.day)")
                .momoText(.graphDay)
        }
    }
}

struct SelectionLine: View {
    let preferences: Anchor<CGRect>?
    
    var body: some View {
        let width: CGFloat = 4
        
        GeometryReader { geometry in
            preferences.map {
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(Color.momo)
                    .frame(width: width, height: geometry[$0].height)
                    .frame(
                        width: geometry.size.width,
                        height: geometry[$0].height,
                        alignment: .center
                    )
                    .shadow()
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
