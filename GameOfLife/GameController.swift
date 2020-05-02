//
//  ViewController.swift
//  GameOfLife
//
//  Created by Hongze Xia on 17/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit
import os.log

class GameController: NSViewController, NSWindowDelegate {
    @IBOutlet var skView: SKView!
    var scene: GameScene? = nil

    func loadSkView() {
        if let view = self.skView {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.setup(rows: INIT_NROWS, cols: INIT_NCOLS)
                scene.scaleMode = .fill
                self.scene = scene
                view.presentScene(scene)
                os_log("loaded scene", type: .debug)
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    func resetScene(cols: Int, rows: Int) {
        scene?.initGrid(cols, cols)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded GameController")
        loadSkView()
    }

    /**
     * skView has to be paused on window close
     * and then resumed when the view comes back.
     * otherwise, the game scene is not responsive.
     * This is made possible by using NSWindowDelegate.
     */
    override func viewDidAppear() {
        skView.isPaused = false
    }

    func windowWillClose(_ notification: Notification) {
        skView.isPaused = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        view.window?.delegate = self
    }
}

