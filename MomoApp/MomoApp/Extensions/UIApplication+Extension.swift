//
//  UIApplication + Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-02.
//

import SwiftUI

extension UIApplication {
    /// Force first responder to resign by sending an action to the shared application.
    /// Please see: https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
