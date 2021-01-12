//
//  Binding+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-13.
//

import SwiftUI

extension Binding {
    /// Please see: https://www.hackingwithswift.com/articles/224/common-swiftui-mistakes-and-how-to-fix-them?utm_source=SwiftLee+-+Subscribers&utm_campaign=3c6b8fddc4-EMAIL_CAMPAIGN_2020_03_02_08_48_COPY_01&utm_medium=email&utm_term=0_e154f6bfee-3c6b8fddc4-396909382
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }

    func unwrap<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
        guard let value = self.wrappedValue else { return nil }
        return Binding<Wrapped> (
            get: { value },
            set: { self.wrappedValue = $0 }
        )
    }
}
