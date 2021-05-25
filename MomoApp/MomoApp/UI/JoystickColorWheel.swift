//
//  BlurredColorWheel.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-17.
//

import SwiftUI

struct JoystickColorWheel: View {
    @Binding var section: ColorWheelSection
    @Binding var isActivated: Bool

    private var gradient: AngularGradient {
        AngularGradient(gradient: .momo(.triColor),
                        center: .center,
                        angle: .degrees(-90))
    }
    
    var body: some View {
        Circle()
            .strokeBorder(self.gradient, lineWidth: 50)
            .animation(.easeInOut(duration: 1.5))
            .mask(
                Circle()
                    .trim(from: 0.0, to: 1/3)
                    .stroke(self.gradient, lineWidth: 80)
                    .rotationEffect(Angle(degrees: 210))
                    .rotationEffect(Angle(degrees: self.section.degrees))
            )
            .blur(radius: 40)
            .opacity(self.isActivated ? 1 : 0)
            .animation(.activateColorWheel, value: self.isActivated)
    }
}

// MARK: - Animation+Extension

extension Animation {
    /// Activate `BlurredColorWheel`.
    static var activateColorWheel: Animation {
        return self.easeInOut(duration: 1.0)
    }
}
