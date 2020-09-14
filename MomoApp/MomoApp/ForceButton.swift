//
//  ForceButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-14.
//

import UIKit
import SwiftUI

class ForceButton: UIView {
    var forceVal: CGFloat = 0.0
    
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
        guard let touch = touches.first else { return }
        if self.traitCollection.forceTouchCapability == .available {
            forceVal = touch.force
        } else {
            print("3D Touch is not available on this device")
        }
    }
    
}

struct ForceButton_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
