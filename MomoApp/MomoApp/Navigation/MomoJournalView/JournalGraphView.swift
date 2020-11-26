//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

/*
 Inspired by: https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f
 */

import SwiftUI

struct JournalGraphView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State var numOfEntries: Int
    @State var indexSelection: Int = 0

    private var entries: [Entry] {
        return viewModel.entries.suffix(numOfEntries)
    }

    private var items: CGFloat { CGFloat(numOfEntries) }

    @State var value: CGFloat

    var date = Date()

    // Selection Line
    @State private var location: CGPoint = .zero
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var isLongPress: Bool = false

    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    private var totalOffset: CGFloat { currentOffset + dragOffset }

    // MARK: - Body

    var body: some View {
        ZStack {
            GeometryReader { geo in

                // Calculate the spacing between graph lines
                let itemWidth: CGFloat = 25
                let itemFrameSpacing = (geo.size.width - (itemWidth * items)) / (items - 1)
                let itemSpacing = itemWidth + itemFrameSpacing
                let columnLayout: [GridItem] = Array(
                    repeating: .init(.flexible(), spacing: itemFrameSpacing),
                    count: numOfEntries)

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< numOfEntries) { idx in
                        VStack {
                            GraphLine(value: self.entries[idx].value)
                                .anchorPreference(
                                    key: SelectionPreferenceKey.self,
                                    value: .bounds,
                                    transform: { anchor in
                                        self.indexSelection == idx ? anchor : nil
                                    })
                            VStack(spacing: 8) {
                                Text("\(self.entries[idx].date.getWeekday())")
                                    .momoText(.graphWeekday)
                                Text("\(self.entries[idx].date.getDay())")
                                    .momoText(.graphDay)
                            }
                        }
                        .frame(minWidth: itemWidth, minHeight: geo.size.height)

                        // Make whole stack tappable
                        .contentShape(Rectangle())
                        .gesture(
                            // Using 'LongPressGesture' to avoid multiple quick taps
                            LongPressGesture(minimumDuration: 0.1)
                                .updating($isLongPress) { value, state, transaction in

                                }.onEnded { _ in
                                    let indexShift = idx - self.indexSelection
                                    let newOffset = itemSpacing * CGFloat(indexShift)
                                    self.snap(to: newOffset)
                                    self.updateIndexSelection(by: indexShift)
                                }
                        )






                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(value: $value, preferences: preferences)
                                .position(x: self.location.x + itemWidth / 2, y: geo.size.height / 2)
                                .offset(x: self.totalOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            var newLocation = self.location

                                            // Protect from scrolling out of bounds
                                            let maxShiftLeft = self.indexSelection * Int(itemSpacing)
                                            let maxShiftRight = (self.numOfEntries - self.indexSelection - 1) * Int(itemSpacing)

                                            print(maxShiftLeft)
                                            print(maxShiftRight)

                                            newLocation.x = min(
                                                0,
                                                newLocation.x + CGFloat(maxShiftRight)
                                            )

                                            self.location = newLocation



                                            // Calculate out of bounds threshold
                                            //                                            let indexShift = Int(round(value.translation.width / itemSpacing))
                                            //                                            let offsetDistance = itemSpacing * CGFloat(indexShift)
                                            //                                            let boundsThreshold = 0 * itemSpacing
                                            //                                            let bounds = (
                                            //                                                min: -(itemSpacing * CGFloat(items - 1) + boundsThreshold),
                                            //                                                max: boundsThreshold
                                            //                                            )
                                            //
                                            //                                            // Protect from scrolling out of bounds
                                            //                                            if value.translation.width > bounds.max {
                                            //                                                self.dragOffset = offsetDistance + boundsThreshold
                                            //                                            }
                                            //                                            else if value.translation.width < bounds.min {
                                            //                                                self.dragOffset = offsetDistance - boundsThreshold
                                            //                                            }

                                        }.updating($startLocation) { value, state, _ in
                                            state = startLocation ?? location
                                        }.onEnded { value in
                                            //                                            let indexShift = Int(round(value.translation.width / itemSpacing))
                                            //                                            let newOffset = itemSpacing * CGFloat(indexShift)
                                            //                                            self.snap(to: newOffset)
                                            //                                            self.updateIndexSelection(by: indexShift)
                                        }
                                )



                            //                                .modifier(
                            //                                    ScrollingLineModifier(
                            //                                        items: numOfEntries,
                            //                                        itemWidth: itemWidth,
                            //                                        itemSpacing: itemSpacing,
                            //                                        index: index,
                            //                                        prevIndex: indexSelection))
                        })
                    }
                }

                // TODO: - Fix animation to the line when it appears
                LineGraphView(dataPoints: self.viewModel.dataPoints)
                    .padding()

                VStack {
                    Text("IDX Selection: \(self.indexSelection)")
                    Text("Location: \(self.location.x)")
                    Text("Drag: \(self.dragOffset)")
                }
            }
        }
        .padding()
        .onAppear {
            // Current day is default selection
            self.indexSelection = self.entries.count - 1
        }
    }

    // MARK: - Internal Methods

    private func onDragEnded(drag: DragGesture.Value) {
    }

    private func snap(to offset: CGFloat) {
        withAnimation(.ease()) {
            self.currentOffset += CGFloat(offset)
            self.dragOffset = 0
        }
    }

    private func updateIndexSelection(by indexShift: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.currentOffset = 0
            self.indexSelection += indexShift
        }
    }
}

// MARK: - Views

struct SelectionLineTest: View {
    let width: CGFloat = 4

    var body: some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(Color.momo)
            .frame(width: width)
    }
}

struct SelectionLine: View {
    @Binding var value: CGFloat
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
                    .contentShape(Rectangle())

                    // Data Point
                    .overlay(
                        Circle()
                            .strokeBorder(Color.momo, lineWidth: 4)
                            .frame(width: 16)
                    )
            }
        }
    }
}

struct GraphLine: View {
    var value: CGFloat

    var body: some View {
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

// MARK: - Preference Keys

struct SelectionPreferenceKey: PreferenceKey {
    static var defaultValue: Value = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}

// MARK: - Previews

struct JournalGraphView_Previews: PreviewProvider {
    static var previews: some View {
        JournalGraphView(numOfEntries: 7, value: CGFloat(0.5))
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
            .environmentObject(ViewRouter())
    }
}
