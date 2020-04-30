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
    
    @IBAction func onClickNewGame(_ sender: AnyObject?) {
        if let _ = gameController {
            // confirmed gameController is set correctly
        }
    }
}
