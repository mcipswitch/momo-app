//
//  CustomTextFieldStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-25.
//

import SwiftUI

struct EmotionTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .momoText()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(Color.momo)
            .minimumScaleFactor(0.7)
    }
}
