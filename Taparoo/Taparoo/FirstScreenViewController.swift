//
//  FirstScreenViewController.swift
//  Taparoo
//
//  Created by david padawer on 8/24/17.
//  Copyright © 2017 DPad Studios. All rights reserved.
//

import Foundation
import Skillz

class FirstScreenViewController : UIViewController {

    override func viewDidLoad() {
        Skillz.skillzInstance().launch();
    }

}
