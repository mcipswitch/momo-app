//
//  TouchButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-28.
//

import UIKit
import SwiftUI

class ForceButton: UIButton {
    
}

struct CustomView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        let touchButton = UIView()
        touchButton.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(sender:)))
        longPressGesture.delegate = context.coordinator
        touchButton.addGestureRecognizer(longPressGesture)
        return touchButton
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: UIView
        init(_ parent: UIView) {
            self.parent = parent
        }
        
        @objc func handleLongPress(sender: UIView) {
            print("long press")
        }
        
        
        
    }
}


struct TouchButton_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
