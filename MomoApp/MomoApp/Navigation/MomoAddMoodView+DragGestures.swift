//
//  MomoAddMoodView+DragGestures.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-03-22.
//

import SwiftUI

extension MomoAddMoodView {

    /// Please see: https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged
    var resistanceDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged(self.onDragChanged(drag:))
            .updating(self.$dragState) { value, state, _ in
                state = .active(location: value.location, translation: value.translation)
            }
            .onEnded(self.onDragEnded(drag:))
    }

    private func onDragChanged(drag: DragGesture.Value) {
        self.viewStore.send(.form(.set(\.joystickIsDragging, true)))

        /// The lower the limit, the tighter the resistance
        let limit: CGFloat = 200
        let xOff = drag.translation.width
        let yOff = drag.translation.height
        let dist = sqrt(xOff*xOff + yOff*yOff);
        let factor = 1 / (dist / limit + 1)

        self.viewStore.send(
            .joystickDragValueChanged(CGSize(width: xOff * factor,
                                             height: yOff * factor))
        )

        // Do nothing if joystick is just tapped
        if self.joystickTapped {
            return
        }

        // Calculate distance to activate 'BlurredColorWheel'
        let minDistance: CGFloat = 50
        var newLocation = self.dragStart
        newLocation.x += xOff
        newLocation.y += yOff
        let distance = self.dragStart.distance(to: newLocation)

        // Calculate degrees to activate corresponding color wheel section
        let degrees = newLocation.angle(to: self.dragStart)

        // Activate the color wheel if joystick is passed minimum distance
        var activateColorWheel: Bool {
            distance > minDistance
        }
        self.viewStore.send(.joystickDegreesChanged(degrees, activateColorWheel))
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.viewStore.send(.form(.set(\.joystickIsDragging, false)))
    }

    // MARK: - Helper vars

    private var joystickTapped: Bool {
        self.viewStore.dragValue == .zero
    }
}
