//
//  TouchButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-28.
//

import UIKit
import SwiftUI

struct CustomView: UIViewRepresentable {
    func makeUIView(context: Context) -> ForceButton {
        let forceButton = ForceButton(type: .roundedRect)
//        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(sender:)))
//        longPressGesture.delegate = context.coordinator
//        forceButton.addGestureRecognizer(longPressGesture)
        return forceButton
    }
    
    func updateUIView(_ uiView: ForceButton, context: Context) {
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
        
//        @objc func handleLongPress(sender: UIView) {
//            print("long press")
//        }
    }
}


struct TouchButton_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
