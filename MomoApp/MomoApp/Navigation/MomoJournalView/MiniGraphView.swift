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
    
    var date = Date()

    // Selection Line
    @GestureState private var dragState: DragState = .inactive
    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State var value: CGFloat = 0.5
    @State var opacity: Bool = false

    // MARK: - Body

    private func changeIdxSelection(to idx: Int) {
        withAnimation(.ease()) {
            self.idxSelection = idx
        }
    }



    let pressGesture = LongPressGesture(minimumDuration: 0.5, maximumDistance: 0)

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.dragOffset = value.translation.width
            }.onEnded { value in
                self.dragOffset = .zero
            }
    }

    var body: some View {
        // A combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        ZStack {
            GeometryReader { geo in

                LineGraphView(dataPoints: self.dataPoints)
                    .padding()

                // Calculate the spacing between graph lines
                let numOfItems: CGFloat = self.entries.count.floatValue
                let numOfSpaces: CGFloat = numOfItems - 1
                let itemWidth: CGFloat = 25
                let totalItemWidth: CGFloat = itemWidth * numOfItems
                let itemFrameSpacing: CGFloat = (geo.size.width - totalItemWidth) / numOfSpaces
                let itemSpacing: CGFloat = itemWidth + itemFrameSpacing
                let columnLayout: [GridItem] = Array(repeating: .init(.flexible(), spacing: itemFrameSpacing),
                                                     count: self.entries.count)

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< self.entries.count) { idx in
                        GraphLine(
                            idxSelection: self.$idxSelection,
                            idx: idx,
                            entries: self.entries
                        )
                        .frame(minWidth: itemWidth, idealHeight: geo.size.height, maxHeight: geo.size.height)

                        // Make whole stack tappable
                        .contentShape(Rectangle())
                        //                        .onTapGesture {
                        //                            self.changeIdxSelection(to: idx)
                        //                        }
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(preferences: preferences)
                                .opacity(self.opacity ? 1 : 0)
                                .offset(x: self.currentOffset)
                                //.position(x: self.location.x + itemWidth / 2, y: geo.size.height / 2)

                                // TODO: - make this work alongside tap gesture
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            self.dragOffset = value.translation.width
                                        }
                                        .updating($dragState) { value, state, transaction in
                                            state = .active(location: value.location, translation: value.translation)
                                        }
                                        .onEnded { value in
                                            // Calculate the index shift to the closest entry
                                            let indexShift = Int(round(value.translation.width / itemSpacing))

                                            // Protect from scrolling out of bounds
                                            var newIndex = self.idxSelection + indexShift
                                            newIndex = max(0, newIndex)
                                            newIndex = min(self.entries.count - 1, newIndex)

                                            self.changeIdxSelection(to: newIndex)
                                            self.dragOffset = .zero
                                        }
                                )
                        })
                        .onReceive(self.viewRouter.objectWillChange, perform: {
                            // Animate in selection line after graph line animation
                            withAnimation(self.viewRouter.isHome
                                            ? Animation.linear.delay(0.2)
                                            : Animation.easeInOut(duration: 1.5).delay(1.8)) {
                                self.opacity.toggle()
                            }
                        })
                    }
                }
                VStack {
                    Text("IDX Selection: \(self.idxSelection)")
                    Text("Drag: \(self.dragOffset)")
                }
            }
        }
        .padding()
    }

    // MARK: - Internal Methods

    //    private func onDragEnded(drag: DragGesture.Value) {
    //    }
}

// MARK: - Views

struct GraphLine: View {
    @Binding var idxSelection: Int
    let idx: Int
    let entries: [Entry]

    var body: some View {
        VStack {
            line
                .anchorPreference(
                    key: SelectionPreferenceKey.self,
                    value: .bounds,
                    transform: { anchor in
                        self.idxSelection == idx ? anchor : nil
                    })
            VStack(spacing: 8) {
                Text("\(self.entries[idx].date.weekday)")
                    .momoText(.graphWeekday)
                Text("\(self.entries[idx].date.day)")
                    .momoText(.graphDay)
            }
        }
    }

    var line: some View {
        Rectangle()
            .foregroundColor(.clear).frame(width: 1)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.gray, .clear]),
                    startPoint: .bottom,
                    endPoint: .top)
            )
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
