//
//  Animator.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-16.
//

import SwiftUI

// Neaten up the readability with a completion typealias
// All it will take is our updated TimeInterval and return nothing
typealias AnimationBlock = (TimeInterval) -> Void

class Animator {
    // MARK: - Properties -
    // Our animation block to run
    private var animationBlock: AnimationBlock
    // Let's start the delta time at 0
    private var totalTime: TimeInterval = 0
    // We'll need a display link that we'll run on the main thread which will essentially run a selector at every frame
    private var displayLink: CADisplayLink {
        return CADisplayLink(target: self, selector: #selector(updateDeltaTime))
    }
    
    // MARK: - Initialiser -
    // We initialise with a block to run and make sure the link is added to the main runloop
    init(animationBlock: @escaping AnimationBlock) {
        self.animationBlock = animationBlock
        displayLink.add(to: RunLoop.main, forMode: .common)
    }
    
    // MARK: - Private Methods -
    
    // The selector updates the time since the last frame was rendered and passes it to the completion block to handle
    @objc private func updateDeltaTime(link: CADisplayLink) {
        totalTime += link.duration
        animationBlock(totalTime)
    }
    
    // Always invalidate this at the end
    deinit {
        displayLink.invalidate()
    }
}
