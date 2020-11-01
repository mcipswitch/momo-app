//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

// Inspired by: https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f

import SwiftUI

struct JournalGraphView: View {
    @State var value: CGFloat
    @State var activeDay = 0
    let date = Date()
    
    
    // Selection Line
    @State private var currentOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        let days = date.getDates(forLastNDays: 7)
        
        ZStack {
            GeometryReader { geometry in
                let itemWidth: CGFloat = 25
                let screenWidth: CGFloat = geometry.size.width
                let spacing: CGFloat = (screenWidth - (itemWidth * CGFloat(days.count))) / CGFloat(days.count - 1)
                let itemSpacing: CGFloat = itemWidth + spacing
                
                HStack(spacing: spacing) {
                    ForEach(0 ..< days.count) { index in
                        VStack {
                            GraphLine()
                                .anchorPreference(
                                    key: SelectionPreferenceKey.self,
                                    value: .bounds,
                                    transform: { anchor in
                                        self.activeDay == index ? anchor : nil
                                    })
                            Text("\(days[index])")
                                .momoTextBold(size: 14)
                        }
                        // Make whole stack tappable
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.activeDay = index
                        }
                        .frame(width: itemWidth)
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            let indexShift = Int(round(dragOffset / itemSpacing))
                            //let index = self.activeDay + indexShift
                            
                            ZStack {
                                SelectionLine(value: $value, preferences: preferences)
                                    .offset(x: currentOffset + dragOffset)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                self.dragOffset = value.translation.width
                                            }
                                            .onEnded { _ in
                                                // Set final offset (snap to item)
                                                let newOffset = itemSpacing * CGFloat(indexShift)
                                                
                                                withAnimation(.ease()) {
                                                    self.currentOffset += newOffset
                                                    self.dragOffset = 0
                                                }
                                                //self.activeDay = index
                                            }
                                    )
                                VStack {
                                    Text("\(indexShift)")
                                }
                            }
                        })
                    }
                }
                VStack {
                    Text("Active Index: \(self.activeDay)")
                    Text("Current: \(self.currentOffset)")
                    Text("Drag: \(self.dragOffset)")
                }.foregroundColor(.yellow)
                
            }
        }
        .padding()
        .onAppear {
            // As default, current day is active
            self.activeDay = days.count - 1
        }
    }
}

// MARK: - Views

struct SelectionLine: View {
    @Binding var value: CGFloat
    let preferences: Anchor<CGRect>?
    
    var body: some View {
        let width: CGFloat = 10 // 4
        
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
