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
    let selectedEntry: Entry
    let dataPoints: [CGFloat]

    /// Default selection is current day
    @State var idxSelection: Int = 6
    @State private var indexShift: Int = 0
    @State private var newIndex: Int = 6

    // Selection Line
    @GestureState private var dragState: DragState = .inactive
    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State var value: CGFloat = 0.5
    @State var opacity: Bool = false

    var date = Date()

    // MARK: - Body

    var body: some View {
        // A combined gesture that forces the user to long press then drag
        //let pressGesture = LongPressGesture(minimumDuration: 0.5, maximumDistance: 0)
        //let combined = pressGesture.sequenced(before: dragGesture)

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

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< self.entries.count) { idx in

                        ZStack {
                            GraphLine(
                                idxSelection: self.idxSelection,
                                newIdx: self.newIndex,
                                idx: idx,
                                entries: self.entries
                            )
                            .frame(minWidth: itemWidth, idealHeight: geo.size.height, maxHeight: geo.size.height)
                            .border(Color.yellow.opacity(0.2))
                            .onTapGesture {
                                self.changeIdxSelection(to: idx)
                            }
                            .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                                SelectionLine(preferences: preferences)
                                    .opacity(self.opacity ? 1 : 0)
                                    .offset(x: self.currentOffset)

                                    // TODO: - make this work alongside tap gesture
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                self.dragOffset = value.translation.width

                                                // Calculate the index shift to the closest entry
                                                self.indexShift = Int(round(value.translation.width / itemSpacing))
                                                let newOffset = itemSpacing * CGFloat(indexShift)
                                                self.currentOffset = newOffset

                                                // Protect from scrolling out of bounds
                                                self.newIndex = self.idxSelection + self.indexShift
                                                self.newIndex = max(0, self.newIndex)
                                                self.newIndex = min(self.entries.count - 1, self.newIndex)
                                            }
                                            .updating($dragState) { value, state, transaction in
                                                state = .active(location: value.location, translation: value.translation)
                                            }
                                            .onEnded { value in
                                                self.currentOffset = 0
                                                self.idxSelection = newIndex
                                                self.dragOffset = .zero
                                            }
                                    )
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
                }

                LineGraphView(dataPoints: self.dataPoints)
                    .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                    .allowsHitTesting(false)

                VStack {
                    Text("IDX Selection: \(self.idxSelection)")
                    Text("Drag: \(self.dragOffset)")
                }
            }
        }
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
    }

    // MARK: - Internal Methods

    private func changeIdxSelection(to idx: Int) {
        withAnimation(.ease()) {
            self.idxSelection = idx
        }
    }

    //    private func snap(to offset: CGFloat) {
    //        withAnimation(.ease()) {
    //            self.currentOffset += CGFloat(offset)
    //            self.dragOffset = 0
    //        }
    //    }
    //
    //    private func updateIndexSelection(by indexShift: Int) {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
    //            self.currentOffset = 0
    //            self.idxSelection += indexShift
    //        }
    //    }
}

// MARK: - Views

struct GraphLine: View {
    let idxSelection: Int
    let newIdx: Int
    let idx: Int
    let entries: [Entry]

    @State private var on = false

    var body: some View {
        VStack {
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

//                                .modifier(
//                                    ScrollingLineModifier(
//                                        items: numOfEntries,
//                                        itemWidth: itemWidth,
//                                        itemSpacing: itemSpacing,
//                                        index: index,
//                                        prevIndex: indexSelection))
