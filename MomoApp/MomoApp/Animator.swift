//
//  Animator.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-28.
//

import SwiftUI

class Animator: ObservableObject {
    
    // MARK: - Properties and Variables
    var skewValueMin: CGFloat = 4 //1000
    var skewValueMax: CGFloat = 8 //60000
    var speedMin: Double = 1 //360
    var speedMax: Double = 24 //360 * 50
    
    @Published var speed: Double = 0
    @Published var skewValue: CGFloat = 0
    @Published var pct: CGFloat = 0 {
        didSet {
            self.skewValue = (pct * (skewValueMax - skewValueMin)) + skewValueMin
            self.speed = (Double(pct) * (speedMax - speedMin)) + speedMin
        }
    }
    @Published var counter: CGFloat = 0 {
        didSet {
            self.pct = counter / 6
        }
    }
}
