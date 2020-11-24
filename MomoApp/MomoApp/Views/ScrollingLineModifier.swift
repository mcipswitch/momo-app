//
//  ScrollingLineModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-14.
//

import SwiftUI

struct ScrollingLineModifier: ViewModifier {
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
    var prevIndex: Int

    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat, index: Int, prevIndex: Int) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.index = index
        self.prevIndex = prevIndex

        self._currentOffset = State(initialValue: 0)
        self._dragOffset = State(initialValue: 0)
    }

    func body(content: Content) -> some View {
        content
            .offset(x: self.totalOffset)
            .gesture(DragGesture()
                        .onChanged { value in
                            self.dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            // Set final offset (snap to item)
                            let newOffset = self.itemSpacing * CGFloat(self.indexShift)
                            self.snap(to: newOffset)
                        }
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
