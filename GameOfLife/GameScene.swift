//
//  GameScene.swift
//  GameOfLife
//
//  Created by Hongze Xia on 17/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//

import SpriteKit
import GameplayKit
import os.log

let LIVE_COLOR = SKColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0.7))!
let DEAD_COLOR = SKColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.7))!

class GameScene: SKScene {

    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?

    /**
     * private members that have to be initialized before use
     */
    private var grid = [[SKShapeNode]]()
    private var cols: Int!
    private var rows: Int!
    private var xunit: CGFloat!
    private var yunit: CGFloat!
    private var snodeSize: CGSize!
    private var world: World!

    func randomize(_ frac: Float) {
        world.randomize(frac)
        syncFromWorld()
//        print("==============")
//        printWorld()
    }
    
    func flipState(_ i: Int, _ j: Int) {
        let state = world.getState(i, j)
        let node = grid[i][j]
        if state {
            removeChildren(in: [node])
        } else {
            addChild(node)
        }
        world.flipState(i, j)
    }
    
    func flipState(_ diff: [(Int, Int)]) {
        // flip all difference in one go
        removeChildren(in: diff.filter {world.getState($0, $1)}.map {grid[$0][$1]} )
        diff.filter {!world.getState($0, $1)}.forEach {addChild(grid[$0][$1])}
        world.flipState(at: diff)
    }

    func syncFromWorld() {
        // Sync the whole world
        removeAllChildren()
        if let label = self.label {
            addChild(label)
        }
        (world.getLiveCells().map { grid[$0][$1] }) .forEach { addChild($0) }
    }

    func setup(rows: Int, cols: Int) {
        (self.cols, self.rows) = (cols, rows)
        if world != nil {
            removeChildren(in: world.getLiveCells().map { grid[$0][$1] })
        }
        self.world = World(rows, cols)
        initGrid(rows, cols)
    }

    func createNode(_ i: Int, _ j: Int) -> SKShapeNode {
        // create only, do not add to node or to grid
        let node = SKShapeNode(rectOf: snodeSize)
        node.position = CGPoint(x: CGFloat(i) * xunit + CGFloat(0.5) * (xunit - size.width), y: CGFloat(j) * yunit + CGFloat(0.5) * (yunit - size.height))
        node.fillColor = LIVE_COLOR
        node.strokeColor = SKColor.green
        return node
    }

    func initGrid(_ rows: Int, _ cols: Int) {
        (xunit, yunit) = (size.width / CGFloat(rows), size.height / CGFloat(cols))
        snodeSize = CGSize(width: xunit, height: yunit)
        grid = []
        for i in 0..<rows {
            grid.append(
                (0..<cols).map { j in
                    createNode(i, j)
                }
            )
        }
    }

    func step() -> Bool {
        let diff = world.stepNew()
        flipState(diff)
        return !diff.isEmpty
    }

    func getGridPos(atPoint pos: CGPoint) -> (Int, Int) {
        let i = Int((pos.x + CGFloat(0.5) * size.width) / xunit)
        let j = Int((pos.y + CGFloat(0.5) * size.height) / yunit)
        return (i, j)
    }

    override func didMove(to view: SKView) {

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//gameOfLife") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        let (i, j) = getGridPos(atPoint: pos)
        flipState(i, j)
    }

    func touchMoved(toPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }

    func touchUp(atPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func printWorld() {
        world.printWorld()
    }
}
