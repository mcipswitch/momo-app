//
//  GradientView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1254901961, green: 0.0862745098, blue: 0.2745098039, alpha: 1)), Color(#colorLiteral(red: 0.2156862745, green: 0.1450980392, blue: 0.4196078431, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            )
            .edgesIgnoringSafeArea(.all)
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
