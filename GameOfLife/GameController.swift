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

class GameController: NSViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSkView()
    }
    
    override func viewDidAppear() {
        print("view did appear \(String(describing: skView))")
        print("scene is \(String(describing: scene))")
//        skView!.awakeFromNib()
        skView!.display()
//        loadSkView()
//        skView!.window!.makeFirstResponder(skView)
//        if scene!.becomeFirstResponder() {
//            print("have become first responder")
//        }
//        skView!.window!.acceptsMouseMovedEvents = true
//        skView!.window!.makeFirstResponder(skView!.scene)
//        if scene!.isPaused {
//            print("scene is paused")
//            scene!.isPaused = false
//        }
    }

    func resetScene(cols: Int, rows: Int) {
        scene?.initGrid(cols: cols, rows: cols)
    }
}

