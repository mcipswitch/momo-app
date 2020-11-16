//
//  ScrollingLineModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-14.
//

import SwiftUI

struct ScrollingLineModifier: ViewModifier {

    @EnvironmentObject var env: GlobalEnvironment
    @State private var currentOffset: CGFloat
    @State private var dragOffset: CGFloat

    private var totalOffset: CGFloat {
        currentOffset + dragOffset
    }

    private var indexShift: Int {
        // Calculate which line to snap to
        Int(round(dragOffset / itemSpacing))
    }

    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    var index: Int
    var tapGesture: Bool

    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat, index: Int, tapGesture: Bool) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.index = index
        self.tapGesture = tapGesture

        self._currentOffset = State(initialValue: 0)
        self._dragOffset = State(initialValue: 0)
    }

    func body(content: Content) -> some View {
        content
            .offset(x: self.totalOffset)
            .gesture(tapGesture ?
                        TapGesture()
                        .onEnded { _ in
                            let indexShift = index - self.env.indexSelection
                            self.env.shiftIndex(by: indexShift)
                            self.currentOffset = 0
                        } : nil
            )
            .gesture(!tapGesture ?
                        DragGesture()
                        .onChanged { value in

                            print("currentOffset: \(self.currentOffset)")
                            print("dragOffset: \(self.dragOffset)")

                            self.dragOffset = value.translation.width

                            // Calculate out of bounds threshold
                            //                            let offsetDistance = itemSpacing * CGFloat(indexShift)
                            //                            let boundsThreshold = 0.25 * itemSpacing
                            //                            let bounds = (
                            //                                min: -(itemSpacing * CGFloat(items - 1) + boundsThreshold),
                            //                                max: boundsThreshold
                            //                            )

                            // Protect from scrolling out of bounds

                            // WHY DOES THIS DISAPPEAR WHEN THE GESTURE GOES OUT OF BOUNDS???

                            //                            if self.totalOffset > bounds.max {
                            //                                self.dragOffset = offsetDistance + boundsThreshold
                            //                            }
                            //                            else if self.totalOffset < bounds.min {
                            //                                self.dragOffset = offsetDistance - boundsThreshold
                            //                            }
                        }
                        .onEnded { value in



                            // Set final offset (snap to item)
                            let newOffset = self.itemSpacing * CGFloat(self.indexShift)

                            self.snap(to: newOffset)
                            self.env.shiftIndex(by: indexShift)




                            print("currentOffset: \(self.currentOffset)")
                            print("dragOffset: \(self.dragOffset)")

                        } : nil
            )
    }

    // MARK: - Internal Methods

    private func snap(to offset: CGFloat) {
        withAnimation(.ease()) {
            self.currentOffset += CGFloat(offset)
            self.dragOffset = 0
        }
    }
}
