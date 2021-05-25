//
//  ViewStore+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-02-22.
//

import SwiftUI
import ComposableArchitecture

extension ViewStore {
    func binding<Value>(
        keyPath: WritableKeyPath<State, Value>,
        send action: @escaping (FormAction<State>) -> Action
    ) -> Binding<Value> where Value: Hashable {
        self.binding(
            get: { $0[keyPath: keyPath] },
            send: { action(.init(keyPath, $0)) }
        )
    }
}
