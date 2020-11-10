//
//  JoystickModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-02.
//

import SwiftUI

struct SelectionLineModifier: ViewModifier {
    @State private var currentOffset: CGFloat
    @State private var dragOffset: CGFloat
    
    var action: () -> Void = {}
    
    var itemSpacing: CGFloat
    
    init(itemSpacing: CGFloat) {
        self.itemSpacing = itemSpacing
        
        // Set Initial Offset to 0
        self._currentOffset = State(initialValue: 0)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: currentOffset + dragOffset)
            .gesture(DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { _ in
                            // Calculate which item we are closest to
                            let indexShift = Int(round(dragOffset / itemSpacing))
                            
                            
//                            // Protect from scrolling out of bounds
//                            index = min(index, CGFloat(items) - 1)
//                            index = max(index, 0)
                            
                            // Calculate final offset
                            let newOffset = itemSpacing * CGFloat(indexShift)
                            
                            // Animate snapping
                            withAnimation(.ease()) {
                                self.currentOffset += newOffset
                                self.dragOffset = 0
                            }
                        }
            )
    }
}
