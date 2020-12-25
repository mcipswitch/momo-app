//
//  JoystickModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

struct JoystickModifier: ViewModifier {
    @Binding var homeViewActive: Bool
    @Binding var dragValue: CGSize

    let dragStart: CGPoint
    let updateDragValue: (CGSize) -> Void
    let onDragChanged: () -> Void
    let onDragEnded: () -> Void
    let activateColorWheel: (Bool) -> Void
    let updateDegrees: (CGFloat) -> Void

    init(
        homeViewActive: Bool,
        dragValue: CGSize,
        dragStart: CGPoint,
        updateDragValue: @escaping (CGSize) -> Void,
        onDragChanged: @escaping () -> Void,
        onDragEnded: @escaping () -> Void,
        activateColorWheel: @escaping (Bool) -> Void,
        updateDegrees: @escaping (CGFloat) -> Void
    ) {
        self.dragStart = dragStart
        self.updateDragValue = updateDragValue
        self.onDragChanged = onDragChanged
        self.onDragEnded = onDragEnded
        self.activateColorWheel = activateColorWheel
        self.updateDegrees = updateDegrees

        self._homeViewActive = .constant(true)
        self._dragValue = .constant(CGSize.zero)
    }

    var resistanceDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { drag in

                /// The lower the limit, the tigher the resistance
                let limit: CGFloat = 200
                let xOff = drag.translation.width
                let yOff = drag.translation.height
                let dist = sqrt(xOff*xOff + yOff*yOff);
                let factor = 1 / (dist / limit + 1)



                let dragValue = CGSize(width: xOff * factor,
                                       height: yOff * factor)
                self.updateDragValue(dragValue)

                // Calculate distance to activate 'BlurredColorWheel'
                let maxDistance: CGFloat = 50
                var newLocation = self.dragStart
                newLocation.x += xOff
                newLocation.y += yOff
                let distance = self.dragStart.distance(to: newLocation)


                self.activateColorWheel(distance > maxDistance ? true : false)

                let degrees = newLocation.angle(to: self.dragStart)
                self.updateDegrees(degrees)

                self.onDragChanged()
            }
            .onEnded { drag in
                self.dragValue = .zero

                self.activateColorWheel(false)

                self.onDragEnded()
            }
    }

    func body(content: Content) -> some View {
        content
            .offset(x: self.dragValue.width * 0.8,
                    y: self.dragValue.height * 0.8)
            .highPriorityGesture(self.homeViewActive ? nil : self.resistanceDrag)
    }
}
