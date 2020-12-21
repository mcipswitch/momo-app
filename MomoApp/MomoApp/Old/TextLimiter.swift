//
//  TextLimiter.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-22.
//

import SwiftUI
import Combine

class TextLimiter: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var hasReachedLimit = false

    @Published var userInput = "" {
        didSet {
            if userInput.count > limit {
                userInput = String(userInput.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
}
