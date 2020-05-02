//
//  GameSideController.swift
//  GameOfLife
//
//  Created by Hongze Xia on 30/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//

import Foundation
import Cocoa

class GameSideController: NSViewController {
    @IBOutlet var newGameBut: NSButton!
    @IBOutlet var startBut: NSButton!
    @IBOutlet var densitySlider: NSSlider!
    weak var gameController: GameController!
    private var delay: UInt32 = 100000 // 0.1 sec == 100000, usleep(delay)
    
    @IBAction func onClickNewGame(_ sender: AnyObject?) {
        if let _ = gameController {
            // confirmed gameController is set correctly
        }
    }
    
    func setDelay(delay: UInt32) {
        self.delay = delay
    }
}
