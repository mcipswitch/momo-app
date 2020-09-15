//
//  Animator.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-28.
//

import SwiftUI

typealias AnimationBlock = (TimeInterval) -> Void

class Animator {
    
    // MARK: - Properties
    private var animationBlock: AnimationBlock
    private var totalTime: TimeInterval = 0
    private var displayLink: CADisplayLink {
        return CADisplayLink(target: self, selector: #selector(handleUpdate))
    }
    
    // MARK: - Initialiser
    init(animationBlock: @escaping AnimationBlock) {
        self.animationBlock = animationBlock
        displayLink.add(to: .main, forMode: .default)
    }
    
    // MARK: - Private Methods
    @objc private func handleUpdate(link: CADisplayLink) {
        totalTime += link.duration
        animationBlock(totalTime)
    }
    
    deinit {
        displayLink.invalidate()
    }
    
}
