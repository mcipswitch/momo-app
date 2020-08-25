//
//  TextLimiter.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-22.
//

import SwiftUI

class TextLimiter: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var hasReachedLimit = false
    
    @Published var userInput = "" {
        didSet {
            if userInput.count > limit && oldValue.count <= limit {
                userInput = String(userInput.prefix(limit))
                hasReachedLimit = true
            } else {
                hasReachedLimit = false
            }
        }
    }
}
