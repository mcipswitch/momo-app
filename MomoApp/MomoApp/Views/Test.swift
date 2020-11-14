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

struct Test: View {
    @State var value: CGFloat
    
    @State private var nDays: Int = 7
    @State private var currentDay: Int = 0
    @State private var selectedDay: Int = 0
    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    @State private var isSelected: Bool = false
    

    var date = Date()

    private var scale: CGFloat {
        return CGFloat(nDays)
    }

    private var totalOffset: CGFloat {
        return currentOffset + dragOffset
    }
    
    var body: some View {
        let days = date.getDates(forLastNDays: nDays)
        let itemWidth: CGFloat = 25
        let columnLayout: [GridItem] = Array(
            repeating: .init(.flexible(), spacing: itemWidth),
            count: nDays)
        
        ZStack {
            GeometryReader { geometry in

                // Calculate the spacing between graph lines
                let itemFrameSpacing = (geometry.size.width - (itemWidth * scale)) / (scale - 1)
                let itemSpacing = itemWidth + itemFrameSpacing

                // Calculate which line we are closest to
                let indexShift = Int(round(dragOffset / itemSpacing))
                let selectedIndex = selectedDay + indexShift
                
                LazyVGrid(
                    columns: columnLayout,
                    alignment: .center
                ) {
                    ForEach(0 ..< nDays) { index in
                        VStack {
                            GraphLine()
                                .anchorPreference(
                                    key: SelectionPreferenceKey.self,
                                    value: .bounds,
                                    transform: { anchor in
                                        self.currentDay == index ? anchor : nil
                                    })
                            Text("\(days[index])")
                                .momoTextBold(size: 14)
                        }
                        .frame(minWidth: itemWidth, minHeight: geometry.size.height)
                        .border(Color.yellow.opacity(0.1))
                        
                        // Make whole stack tappable
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // Calculate final offset
                            let indexShift = index - selectedIndex
                            let offset = itemSpacing * CGFloat(indexShift)
                            self.handleSnap(to: offset)
                            self.selectedDay = index
                        }
                        
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(value: $value, preferences: preferences)
                                .offset(x: self.totalOffset)
                                .gesture(DragGesture()
                                            .onChanged { value in
                                                dragOffset = value.translation.width
                                                
                                                // Calculate out of bounds threshold
                                                let offsetBounds = itemSpacing * CGFloat(indexShift)
                                                let threshold = 0.25 * itemSpacing
                                                let bounds = (
                                                    min: -(itemSpacing * (scale - 1) + threshold),
                                                    max: threshold
                                                )
                                                // Protect from dragging out of bounds
                                                if self.totalOffset > bounds.max {
                                                    dragOffset = offsetBounds + threshold
                                                }
                                                if self.totalOffset < bounds.min {
                                                    dragOffset = offsetBounds - threshold
                                                }
                                            }
                                            .onEnded { value in
                                                let offset = itemSpacing * CGFloat(indexShift)
                                                self.handleSnap(to: offset)
                                                self.selectedDay = selectedIndex
                                            }
                                )
                        })
                    }
                }
                VStack {
                    Text("Active Idx: \(self.currentDay)")
                    Text("Selected Idx: \(self.selectedDay)")
                    Text("Current: \(self.currentOffset)")
                    Text("Drag: \(self.dragOffset)")
                }
                .foregroundColor(Color.gray.opacity(0.5))
            }
        }
        .padding()
        .onAppear {
            // As default, current day is active
            self.currentDay = days.count - 1
            self.selectedDay = currentDay
        }
    }
    
    // MARK: - Internal Methods
    
    private func handleSnap(to offset: CGFloat) {
        withAnimation(.ease()) {
            self.currentOffset += CGFloat(offset)
            self.dragOffset = 0
        }
    }
    
}

// MARK: - Previews

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test(value: CGFloat(0.5))
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
