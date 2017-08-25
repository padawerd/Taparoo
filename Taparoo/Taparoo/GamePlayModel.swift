//
//  GamePlayModel.swift
//  Taparoo
//
//  Created by david padawer on 8/15/17.
//  Copyright © 2017 DPad Studios. All rights reserved.
//

import UIKit

struct GamePlayModel {

    var currentNotes = [Note]()
    var score = 0;
    var currentMultiplier = 1;
    var streak = 0;
    var gameSpeed = 1.0
    var ticksUntilGone = 5
    var hitSlop = 20
    var secondsLeft = 60
    
}
