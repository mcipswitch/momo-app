//
//  ScrollingLineModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-14.
//

import SwiftUI

struct ScrollingLineModifier: ViewModifier {
    @State private var currentOffset: CGFloat
    @State private var newIdx: Int

    let items: Int
    let itemWidth: CGFloat
    let itemSpacing: CGFloat
    let idxSelection: Int
    //let onDragEnded: (Int) -> ()

    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat, idxSelection: Int) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.idxSelection = idxSelection
        //self.onDragEnded = onDragEnded

        self._currentOffset = State(initialValue: 0)
        self._newIdx = State(initialValue: 0)
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in

                // Calculate the index shift to the closest entry
                let indexShift = Int(round(value.translation.width / itemSpacing))
                let newOffset = itemSpacing * CGFloat(indexShift)

                self.currentOffset = newOffset

                // Protect from scrolling out of bounds
                self.newIdx = self.idxSelection + indexShift
                self.newIdx = max(0, self.newIdx)
                self.newIdx = min(self.items - 1, self.newIdx)

            }.onEnded { value in
                self.currentOffset = 0

                // call handler
                //self.onDragEnded(self.newIdx)

                //self.idxSelection = self.idx
            }
    }

    func body(content: Content) -> some View {
        content
            .offset(x: self.currentOffset)
            .gesture(dragGesture)
    }
}
