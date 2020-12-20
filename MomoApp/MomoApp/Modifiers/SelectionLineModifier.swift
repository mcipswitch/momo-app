//
//  SelectionLineModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-14.
//

import SwiftUI

struct SelectionLineModifier: ViewModifier {
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
            .onChanged(onDragChanged(drag:))
            .onEnded(onDragEnded(drag:))
    }

    func body(content: Content) -> some View {
        content
            .offset(x: self.dragOffset)
            .gesture(dragGesture)
    }

    // MARK: - Internal Methods

    private func onDragChanged(drag: DragGesture.Value) {

        // Calculate the index shift to the closest entry
        let indexShift = Int(round(drag.translation.width / itemSpacing))
        let newOffset = itemSpacing * CGFloat(indexShift)
        self.dragOffset = newOffset
        self.newIdx = self.selectedIdx + indexShift

        self.protectFromScrollingOutOfBounds()
    }

    private func protectFromScrollingOutOfBounds() {
        self.newIdx = max(0, self.newIdx)
        self.newIdx = min(self.items - 1, self.newIdx)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.dragOffset = .zero
        self.onDragEnded(self.newIdx)
    }
}