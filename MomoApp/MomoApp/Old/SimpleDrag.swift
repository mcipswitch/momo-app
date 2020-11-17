//
//  SimpleDrag.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-17.
//

import Foundation

// MARK: - Old

//var simpleDrag: some Gesture {
//    DragGesture(minimumDistance: 0)
//        .onChanged { value in
//            self.isDragging = true
//
//            guard let startLocation = startLocation else { return }
//            let maxDistance: CGFloat = 40
//            var newLocation = startLocation
//            newLocation.x += value.translation.width
//            newLocation.y += value.translation.height
//            let distance = startLocation.distance(to: newLocation)
//            if distance > maxDistance {
//                self.blurredColorWheelIsActive = (distance > maxDistance * 1.2) ? true : false
//                let k = maxDistance / distance
//                let locationX = ((newLocation.x - startLocation.x) * k) + startLocation.x
//                let locationY = ((newLocation.y - startLocation.y) * k) + startLocation.y
//                self.buttonLocation = CGPoint(x: locationX, y: locationY)
//            } else {
//                self.buttonLocation = newLocation
//            }
//
//            guard let location = buttonLocation else { return }
//            self.degrees = location.angle(to: startLocation)
//            self.pct = self.degrees / 360
//
//        }.updating($startLocation) { value, state, _ in
//            // Set startLocation to current button position
//            // It will reset once the gesture ends
//            state = startLocation ?? buttonLocation
//        }.onEnded { value in
//            self.buttonLocation = self.originalPos
//            self.isDragging = false
//            self.blurredColorWheelIsActive = false
//            self.isResetting = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isResetting = false
//            }
//        }
//}
