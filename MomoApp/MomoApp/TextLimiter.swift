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
    
    @Published var text = "" {
        didSet {
            if text.count > limit && oldValue.count <= limit {
                text = String(text.prefix(limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}
