//
//  GameSideController.swift
//  GameOfLife
//
//  Created by Hongze Xia on 30/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//

import Foundation
import Cocoa
import os.log

class GameSideController: NSViewController {
    @IBOutlet var newGameBut: NSButton!
    @IBOutlet var startBut: NSButton!
    @IBOutlet var densitySlider: NSSlider!
    @IBOutlet var densityLabel: NSTextField!
    @IBOutlet var colsText: NSTextField!
    @IBOutlet var rowsText: NSTextField!
    private var frac: Float = 0.5
    weak var gameController: GameController!
    
    private var delay: UInt32 = 1000000 // 0.1 sec == 100000, usleep(delay)
    
    @IBAction func onClickNewGame(_ sender: AnyObject?) {
        if let _ = gameController {
            // confirmed gameController is set correctly
        }
    }
    
    @IBAction func onMoveSlider(_ sender: NSSlider) {
        (frac, densityLabel.stringValue) = (sender.floatValue, String(format: "%.2f", sender.floatValue))
    }
    
    func setDelay(delay: UInt32) {
        self.delay = delay
    }
    
    override func viewDidLoad() {
        rowsText.integerValue = INIT_NROWS
        colsText.integerValue = INIT_NCOLS
    }
    
    @IBAction func randomize(_ sender: NSButton) {
        gameController.scene?.randomize(frac)
    }
    
    @IBAction func startOrPause(_ sender: NSButton) {
        var count = 0
        while gameController.scene.step() && sender.state == .on {
            count += 1
            if count % 10 == 0 {
                os_log("at step %d", type: .debug, count)
            }
            gameController.presentScene()
            usleep(delay)
        }
        os_log("paused or stop at step %d", type: .debug, count)
        sender.state = .off
    }
}
