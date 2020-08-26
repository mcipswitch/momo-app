//
//  TapView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-25.
//

import UIKit
import SwiftUI

struct TapView: UIViewRepresentable {
    var tappedCallback: (() -> Void)

    func makeUIView(context: UIViewRepresentableContext<TapView>) -> TapView.UIViewType {
        let v = UIView(frame: .zero)
        let gesture = SingleTouchDownGestureRecognizer(target: context.coordinator,
                                                       action: #selector(Coordinator.tapped))
        v.addGestureRecognizer(gesture)
        return v
    }

    class Coordinator: NSObject {
        var tappedCallback: (() -> Void)

        init(tappedCallback: @escaping (() -> Void)) {
            self.tappedCallback = tappedCallback
        }

        @objc func tapped(gesture:UITapGestureRecognizer) {
            self.tappedCallback()
        }
    }

    func makeCoordinator() -> TapView.Coordinator {
        return Coordinator(tappedCallback:self.tappedCallback)
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<TapView>) {
    }
}





class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            if view?.traitCollection.forceTouchCapability == .available {
                if touch.force == touch.maximumPossibleForce {
                    // user pressed hard - do something!
                }
            }
        }
    }
}
