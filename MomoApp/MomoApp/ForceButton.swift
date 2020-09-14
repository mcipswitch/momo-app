//
//  ForceButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-14.
//

import UIKit
import SwiftUI

class ForceButton: UIButton {
    var forceVal: CGFloat = 0.0
    var maxForceVal: CGFloat = 0.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleForceWithTouches(touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleForceWithTouches(touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handleForceWithTouches(touches)
    }
    
    private func handleForceWithTouches(_ touches: Set<UITouch>) {
//        if touches.count != 1 {
//            print(touches.count)
//            return
//        }
        
        guard let touch = touches.first else { return }
        if self.traitCollection.forceTouchCapability == .available {
            forceVal = touch.force
            maxForceVal = touch.maximumPossibleForce * 100
        } else {
            print("3D Touch is not available on this device")
        }
    }
    
}
