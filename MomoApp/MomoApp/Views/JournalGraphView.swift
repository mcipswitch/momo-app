//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum GraphMode: Int {
    case week = 7
    case month = 30
}

struct JournalGraphView: View {
    @State var value: CGFloat
    @State var activeDay = 0
    let date = Date()
    
    
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        let days = date.getDates(forLastNDays: 7)
        
        ZStack {
            GeometryReader { geometry in
                let defaultWidth: CGFloat = 24
                let spacing: CGFloat = (geometry.size.width - (defaultWidth * CGFloat(days.count))) / CGFloat(days.count - 1)
                
                HStack(spacing: spacing) {
                    ForEach(0 ..< days.count) { day in
                        VStack {
                            GraphLine()
                                .anchorPreference(
                                    key: SelectionPreferenceKey.self,
                                    value: .bounds,
                                    transform: { anchor in
                                        self.activeDay == day ? anchor : nil
                                    })
                            Text("\(days[day])")
                                .momoTextBold(size: 14)
                                .onTapGesture {
                                    self.activeDay = day
                                }
                        }
                        .frame(width: defaultWidth)
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            SelectionLine(value: $value, preferences: preferences)
                                .offset(x: dragOffset.width)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            self.dragOffset = value.translation
                                        }
                                        .onEnded { value in
                                            self.dragOffset = .zero
                                        }
                                )
                        })
                        .animation(Animation.ease())
                    }
                }
            }
        }
        .padding()
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
                    .frame(width: 2, height: geometry[$0].height)
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
