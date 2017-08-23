//
//  Note.swift
//  Taparoo
//
//  Created by david padawer on 8/15/17.
//  Copyright © 2017 DPad Studios. All rights reserved.
//

import Foundation
import UIKit

//TOPLEFT    TOPMIDDLE    TOPRIGHT
//MIDDLELEFT MIDDLEMIDDLE MIDDLERIGHT
//BOTTOMLEFT BOTTOMMIDDLE BOTTOMRIGHT
enum NoteType : Int {
    case TopLeft = 0
    case TopMiddle = 1
    case TopRight = 2
    case MiddleRight = 3
    case BottomRight = 4
    case BottomMiddle = 5
    case BottomLeft = 6
    case MiddleLeft = 7
}

class Note : UIButton {
    var type : NoteType!
    var onClick : (() -> Void)!
    var move : (() -> Void)!
    var ticksOnPoint = 0


    @IBAction func interactClickButton(_ sender: Any) {
        self.onClick()
    }


    @IBOutlet weak var button: UIButton!

    func setup(type: NoteType) {
        self.type = type
    }
}
