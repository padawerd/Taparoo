//
//  GameLoop.swift
//  Taparoo
//
//  Created by david padawer on 8/15/17.
//  Copyright © 2017 DPad Studios. All rights reserved.
//

import UIKit

class GameLoop : NSObject {

    var onTick : (() -> ())!
    var displayLink : CADisplayLink!
    var frameInterval : Int

    init(frameInterval: Int, onTick: @escaping () -> ()) {
        self.onTick = onTick
        self.frameInterval = frameInterval
        super.init()
        start()
    }

    @objc
    func handleTimer() {
        onTick()
    }

    func start() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(handleTimer))
        self.displayLink.frameInterval = frameInterval
        self.displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }

    func stop() {
        if let displayLinkUnwrapped = displayLink {
            displayLinkUnwrapped.invalidate()
            displayLink = nil
        }
    }

    func pause() {
        self.displayLink.isPaused = true
    }

    func unPause() {
        self.displayLink.isPaused = false
    }
}
