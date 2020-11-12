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
    @State var value: CGFloat
    
    @State private var nDays: Int = 7
    @State private var currentDay: Int = 0
    @State private var selectedDay: Int = 0
    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    @State private var isSelected: Bool = false
    
    let date = Date()
    
    var body: some View {
        let days = date.getDates(forLastNDays: nDays)
        
        ZStack {
            GeometryReader { geometry in
                // Calculate equal spacing for graph lines
                let itemWidth: CGFloat = 25
                let numOfSpaces: Int = nDays - 1
                let hStackSpacing = (geometry.size.width - (itemWidth * CGFloat(nDays))) / CGFloat(numOfSpaces)
                
                // Calculate which item we are closest to
                let itemSpacing = itemWidth + hStackSpacing
                let indexShift = Int(round(dragOffset / itemSpacing))
                let selectedIndex = selectedDay + indexShift
                
                HStack(spacing: hStackSpacing) {
                    ForEach(0 ..< nDays) { index in
                        VStack {GraphLine()
                            .anchorPreference(
                                key: SelectionPreferenceKey.self,
                                value: .bounds,
                                transform: { anchor in
                                    self.currentDay == index ? anchor : nil
                                })
                            Text("\(days[index])")
                                .momoTextBold(size: 14)
                        }
                        .frame(width: itemWidth)
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
                                .offset(x: currentOffset + dragOffset)
                                .gesture(DragGesture()
                                            .onChanged { value in
                                                dragOffset = value.translation.width
                                                
                                                // Out of bounds threshold
                                                let threshold = 0.25 * itemSpacing
                                                let minBounds = -(itemSpacing * (CGFloat(numOfSpaces)) + threshold)
                                                let maxBounds = 0 + threshold
                                                
                                                let totalOffset = currentOffset + dragOffset
                                                let offsetBounds = itemSpacing * CGFloat(indexShift)
                                                
                                                // Protect from dragging out of bounds
                                                if totalOffset > maxBounds {
                                                    dragOffset = offsetBounds + threshold
                                                }
                                                if totalOffset < minBounds {
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
        // Animate snapping
        withAnimation(.ease()) {
            self.currentOffset += CGFloat(offset)
            self.dragOffset = 0
        }
    }
    
}

// MARK: - Views

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
                
                //                    .overlay(
                //                        Circle()
                //                            .strokeBorder(Color.momo, lineWidth: 4)
                //                            .frame(width: 18)
                //                    )
            }
        }
    }
}

struct GraphLine: View {
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
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Value = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

// MARK: - Previews

struct JournalGraphView_Previews: PreviewProvider {
    static var previews: some View {
        JournalGraphView(value: CGFloat(0.5))
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
