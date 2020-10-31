//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

// Inspired by: https://levelup.gitconnected.com/snap-to-item-scrolling-debccdcbb22f

import SwiftUI

enum GraphMode: Int {
    case week = 7
    case month = 30
}

struct JournalGraphView: View {
    @State var value: CGFloat
    @State var activeDay = 0
    let date = Date()
    
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        let days = date.getDates(forLastNDays: 7)
        
        ZStack {
            GeometryReader { geometry in
                let itemWidth: CGFloat = 25
                let graphWidth: CGFloat = geometry.size.width
                let spacing: CGFloat = (graphWidth - (itemWidth * CGFloat(days.count))) / CGFloat(days.count - 1)
                
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
                                .onTapGesture {
                                    self.activeDay = index
                                }
                        }
                        .frame(width: itemWidth)
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(value: $value, preferences: preferences)
                                .offset(x: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            self.dragOffset = value.translation.width
                                        }
                                        .onEnded { value in
                                            let indexShift = Int(round(dragOffset / itemSpacing))
                                            self.activeDay += indexShift
                                            self.dragOffset = 0
                                        }
                                )
                        })
                        .animation(Animation.ease())
                    }
                }
                VStack {
                    Text("Index: \(self.activeDay)")
                    Text("Drag: \(self.dragOffset)")
                    Text("\(itemSpacing)")
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
        GeometryReader { geometry in
            preferences.map {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.momo)
                    .frame(width: 10, height: geometry[$0].height)
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
            .frame(width: 1)
            .foregroundColor(.clear)
            .background(LinearGradient(
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
