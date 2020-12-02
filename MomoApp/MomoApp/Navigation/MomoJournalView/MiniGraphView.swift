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
    @State private var location: CGPoint = .zero
    @GestureState private var startLocation: CGPoint? = nil

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

    var body: some View {
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
                        .onTapGesture {
                            self.changeIdxSelection(to: idx)
                        }
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(preferences: preferences)
                                .opacity(self.opacity ? 1 : 0)
                                //.position(x: self.location.x + itemWidth / 2, y: geo.size.height / 2)
                                .offset(x: self.currentOffset + self.dragOffset)
                        })
                        .onReceive(self.viewRouter.objectWillChange, perform: {
                            // Animate in selection line after graph line animation
                            withAnimation(self.viewRouter.isHome
                                            ? Animation.linear.delay(0.2)
                                            : Animation.easeInOut(duration: 1.5).delay(1.8)) {
                                self.opacity.toggle()
                            }
                        })


////                                .gesture(
////                                    DragGesture()
////                                        .onChanged { value in
////
//////                                            // Protect from scrolling out of bounds
//////                                            let maxShiftLeft = self.idxSelection * Int(itemSpacing)
//////                                            let maxShiftRight = (self.numOfEntries - self.idxSelection - 1) * Int(itemSpacing)
//////
//////                                            newLocation.x = min(
//////                                                0,
//////                                                newLocation.x + CGFloat(maxShiftRight)
//////                                            )
//////
//////                                            self.location = newLocation
//////
//////
//////
//////                                            Calculate out of bounds threshold
//////                                            let indexShift = Int(round(value.translation.width / itemSpacing))
//////                                            let offsetDistance = itemSpacing * CGFloat(indexShift)
//////                                            let boundsThreshold = 0 * itemSpacing
//////                                            let bounds = (
//////                                                min: -(itemSpacing * CGFloat(items - 1) + boundsThreshold),
//////                                                max: boundsThreshold
//////                                            )
//////
//////                                            // Protect from scrolling out of bounds
//////                                            if value.translation.width > bounds.max {
//////                                                self.dragOffset = offsetDistance + boundsThreshold
//////                                            }
//////                                            else if value.translation.width < bounds.min {
//////                                                self.dragOffset = offsetDistance - boundsThreshold
//////                                            }
////
////                                        }.updating($startLocation) { value, state, _ in
////                                            //state = startLocation ?? location
////                                        }.onEnded { value in
//////                                            let indexShift = Int(round(value.translation.width / itemSpacing))
//////                                            let newOffset = itemSpacing * CGFloat(indexShift)
//////                                            self.snap(to: newOffset)
//////                                            self.updateIndexSelection(by: indexShift)
////                                        }
////                                )
//                        })
                    }
                }

                VStack {
                    Text("IDX Selection: \(self.idxSelection)")
                    Text("Location: \(self.location.x)")
                    Text("Drag: \(self.dragOffset)")
                }
            }
        }
        .padding()
    }

    // MARK: - Internal Methods

//    private func onDragEnded(drag: DragGesture.Value) {
//    }
//
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
