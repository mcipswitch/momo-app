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

//MARK: - Global Application State

class GlobalEnvironment: ObservableObject {
    @Published var entrySelection: Entry?
    @Published var indexSelection: Int = 6

    func shiftIndex(by amount: Int) {
        withAnimation(Animation.easeInOut(duration: 0.05)) {
            self.indexSelection += amount
        }
    }
}

struct JournalGraphView: View {
    @EnvironmentObject var env: GlobalEnvironment
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @Binding var numOfEntries: Int
    @State var indexSelection: Int?

    private var entries: [Entry] {
        return viewModel.entries.suffix(numOfEntries)
    }

    @State var didTap: Bool = false

    @State var value: CGFloat

    @State private var animateOn: Bool = false

    private var items: CGFloat {
        CGFloat(numOfEntries)
    }

    var date = Date()

    var body: some View {
        ZStack {
            GeometryReader { geometry in

                // Calculate the spacing between graph lines
                let itemWidth: CGFloat = 25
                let itemFrameSpacing = (geometry.size.width - (itemWidth * items)) / (items - 1)
                let itemSpacing = itemWidth + itemFrameSpacing
                let columnLayout: [GridItem] = Array(
                    repeating: .init(.flexible(), spacing: itemFrameSpacing),
                    count: numOfEntries)

                LazyVGrid(columns: columnLayout, alignment: .center) {
                    ForEach(0 ..< numOfEntries) { index in
                        VStack {
                            ZStack {
                                GraphLine()
//                                    .anchorPreference(
//                                        key: SelectionPreferenceKey.self,
//                                        value: .bounds,
//                                        transform: { anchor in
//                                            self.indexSelection == index ? anchor : nil
//                                        })
                                if self.indexSelection == index {
                                    SelectionLineTest()
                                }
                            }
                            .onTapGesture {
                                self.indexSelection = index
                            }


                            VStack(spacing: 8) {
                                Text("\(self.entries[index].date.getWeekday())")
                                    .momoTextBold(size: 12, opacity: 0.4)
                                Text("\(self.entries[index].date.getDay())")
                                    .momoTextBold(size: 14)
                            }
                        }
                        .frame(minWidth: itemWidth, minHeight: geometry.size.height)
                        // Animate on the graph lines
                        .opacity(animateOn ? 1 : 0)
                        .animation(Animation
                                    .easeInOut(duration: 2)
                                    .delay(Double(index) * 0.1)
                        )

//                         Make whole stack tappable
//                        .contentShape(Rectangle())
                        // .onTapGesture { }
                        // .modifier(ScrollingLineModifier(items: numOfEntries, itemWidth: itemWidth, itemSpacing: itemSpacing, index: index, tapGesture: true))
//                        .overlayPreferenceValue(SelectionPreferenceKey.self, { preferences in
//                            SelectionLine(value: $value, preferences: preferences)
//                                .modifier(ScrollingLineModifier(items: numOfEntries, itemWidth: itemWidth, itemSpacing: itemSpacing, index: index, tapGesture: false))
//                        })
                    }
                }
                VStack {
                    Text("ENV Index Selection: \(self.env.indexSelection)")
                    Text("Index Selection: \(self.indexSelection ?? 0)")
                }
                .foregroundColor(Color.gray.opacity(0.2))
            }
        }
        .padding()
        .onAppear {
            self.animateOn = true

            // Current day is default selection
            self.indexSelection = self.entries.count - 1
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
                    //.contentShape(Rectangle())
                
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
        let env = GlobalEnvironment()

        JournalGraphView(numOfEntries: .constant(7), value: CGFloat(0.5))
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
            .environmentObject(env)
    }
}
