//
//  ScrollingLineModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-14.
//

import SwiftUI

struct ScrollingLineModifier: ViewModifier {
    @State private var dragOffset: CGFloat
    @State private var newIdx: Int

    let items: Int
    let itemWidth: CGFloat
    let itemSpacing: CGFloat
    let selectedIdx: Int
    let onDragEnded: (Int) -> Void

    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat, selectedIdx: Int, onDragEnded: @escaping (Int) -> Void) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.selectedIdx = selectedIdx
        self.onDragEnded = onDragEnded

        self._dragOffset = State(initialValue: 0)
        self._newIdx = State(initialValue: 0)
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in

                // Calculate the index shift to the closest entry
                let indexShift = Int(round(value.translation.width / itemSpacing))
                let newOffset = itemSpacing * CGFloat(indexShift)
                self.dragOffset = newOffset

                // Protect from scrolling out of bounds
                self.newIdx = self.selectedIdx + indexShift
                self.newIdx = max(0, self.newIdx)
                self.newIdx = min(self.items - 1, self.newIdx)

            }.onEnded { value in
                self.dragOffset = .zero
                self.onDragEnded(self.newIdx)

                //self.idxSelection = self.idx
            }
    }

    func body(content: Content) -> some View {
        content
            .offset(x: self.dragOffset)
            .gesture(dragGesture)
    }
}
