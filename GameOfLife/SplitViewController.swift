//
//  SplitViewController.swift
//  GameOfLife
//
//  Created by Hongze Xia on 30/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//

import Foundation
import Cocoa
import os.log

let INIT_NCOLS = 4
let INIT_NROWS = 4

class SplitViewController: NSSplitViewController {
    override func awakeFromNib() {
        guard splitViewItems.count == 2 else {
            preconditionFailure("splitViewCount should be exactly 2")
        }

        if let gameSideController = splitViewItems[0].viewController as? GameSideController,
            let gameControler = splitViewItems[1].viewController as? GameController {
            gameSideController.gameController = gameControler
            os_log("setting gameController successfully", type: .debug)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded split view")

    }
}
