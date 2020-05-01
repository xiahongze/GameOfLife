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
    private var scene: GameScene? = nil
    
    func loadSkView() {
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the view
                scene.scaleMode = .fill
                os_log("have converted to GameScene!", type: .debug)
                scene.initGrid(cols: 4, rows: 4)
                // Present the scene
                view.presentScene(scene)

                self.scene = scene
            }

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func resetScene(cols: Int, rows: Int) {
        scene?.initGrid(cols: cols, rows: cols)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

