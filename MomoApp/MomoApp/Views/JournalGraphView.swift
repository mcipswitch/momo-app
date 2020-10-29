//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum GraphType: String {
    case week
    var scale: Int {
        switch self {
        case .week: return 7
        }
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

struct JournalGraphView: View {
    @State var graphType: GraphType = GraphType.week
    @State var activeDay = 0
    var startDate: Int = 5
    
    var body: some View {
        let numOfLines = graphType.scale
        ZStack {
            GeometryReader { geometry in
                HStack(spacing: (geometry.size.width - CGFloat(20 * graphType.scale)) / CGFloat(numOfLines - 1)) {
                    ForEach(0..<numOfLines) { index in
                        VStack {
                            GraphLine()
                                .anchorPreference(
                                    key: SelectionPreferenceKey.self,
                                    value: .bounds,
                                    transform: { anchor in
                                        self.activeDay == index ? anchor : nil
                                    })
                            Text("\(index + startDate)")
                                .momoTextBold(size: 14, opacity: 0.6)
                                .onTapGesture {
                                    self.activeDay = index
                                }
                        }
                        .frame(width: 20)
                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
                            GeometryReader { geometry in
                                preferences.map {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 2, height: geometry[$0].height)
                                        .frame(
                                            width: geometry.size.width,
                                            height: geometry[$0].height,
                                            alignment: .center
                                        )
                                }
                            }
                        })
                    }
                }
            }
            Text("\(activeDay + startDate)")
        }
        .padding()
    }
}

// MARK: - Views

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

// MARK: - Previews

struct JournalGraphView_Previews: PreviewProvider {
    static var previews: some View {
        JournalGraphView()
    }
}
