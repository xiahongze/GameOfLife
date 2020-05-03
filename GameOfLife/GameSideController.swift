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
    @IBOutlet var densitySlider: NSSlider!
    @IBOutlet var densityLabel: NSTextField!
    @IBOutlet var speedSlider: NSSlider!
    @IBOutlet var colsText: NSTextField!
    @IBOutlet var rowsText: NSTextField!
    private var frac: Float = 0.5
    private var running = false
    weak var gameController: GameController!

    private var delay: UInt32 = 1000000 // 0.1 sec == 100000, usleep(delay)

    @IBAction func onClickNewGame(_ sender: AnyObject?) {
        gameController.scene.setup(rows: rowsText.integerValue, cols: colsText.integerValue)
    }

    @IBAction func onMoveSlider(_ sender: NSSlider) {
        (frac, densityLabel.stringValue) = (sender.floatValue, String(format: "%.2f", sender.floatValue))
    }

    func setDelayWith(speed: Int) {
        delay = UInt32(1000000 / speed)
    }

    override func viewDidLoad() {
        rowsText.integerValue = INIT_NROWS
        colsText.integerValue = INIT_NCOLS
        setDelayWith(speed: speedSlider.integerValue)
    }

    @IBAction func randomize(_ sender: NSButton) {
        gameController.scene?.randomize(frac)
    }

    @IBAction func startOrPause(_ sender: NSButton) {
        if running {
            os_log("pause the game", type: .debug)
            running = false
            return
        }
        running = true
        let dispatchQueue = DispatchQueue(label: "runGame", qos: .background)
        dispatchQueue.async {
            //Time consuming task here
            var count = 0
            while self.gameController.scene.step() && self.running {
                count += 1
                if count % 10 == 0 {
                    os_log("at step %d", type: .debug, count)
                }
                usleep(self.delay)
            }
            os_log("stopped at step %d", type: .debug, count)
            self.running = false
        }
    }
    
    
    @IBAction func setSpeed(_ sender: NSSlider) {
        setDelayWith(speed: sender.integerValue)
    }
}
