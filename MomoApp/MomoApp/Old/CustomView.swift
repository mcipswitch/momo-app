//
//  CustomView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-28.
//

import UIKit
import SwiftUI

struct CustomView: UIViewRepresentable {
    @Binding var tappedForceValue: CGFloat
    @Binding var maxForceValue: CGFloat
    
    func makeUIView(context: Context) -> ForceButton {
        let forceButton = ForceButton()
        forceButton.addTarget(
            context.coordinator,
            action: #selector(Coordinator.handleLongPress(sender:)),
            for: .allTouchEvents
        )
        return forceButton
    }
    
    func updateUIView(_ forceButton: ForceButton, context: Context) {
        forceButton.forceVal = tappedForceValue
    }

    final class Coordinator: NSObject {
        var customView: CustomView
        init(_ customView: CustomView) {
            self.customView = customView
        }
        
        @objc func handleLongPress(sender: ForceButton) {
            customView.tappedForceValue = sender.forceVal
            customView.maxForceValue = sender.maxForceVal
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
