//
//  Reducer+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-02-22.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Reducer + Extension

func ~= <Root, Value> (
    keyPath: WritableKeyPath<Root, Value>,
    formAction: FormAction<Root>
) -> Bool {
    formAction.keyPath == keyPath
}

extension Reducer {
    func form(
        action formAction: CasePath<Action, FormAction<State>>
    ) -> Self {
        Self { state, action, environment in
            guard let formAction = formAction.extract(from: action) else {
                return self.run(&state, action, environment)
            }

            formAction.setter(&state)
            return self.run(&state, action, environment)
        }
    }
}
