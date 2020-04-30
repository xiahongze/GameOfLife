//
//  AppDelegate.swift
//  GameOfLife
//
//  Created by Hongze Xia on 17/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var showMenu: NSMenuItem!
    
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
//    var gameSideWindowController = NSWindowController()
//    var gameWindowController = NSWindowController()
    var gameWindows = [String:NSWindowController]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let win = storyboard.instantiateController(withIdentifier: "GameWindowController") as? NSWindowController {
            gameWindows["Game 0"] = win
            win.window?.title = "Game 0"
            win.showWindow(nil)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showGameWindow(_ sender: AnyObject) {
        if let win = gameWindows["Game 0"] {
            win.showWindow(sender)
        }
    }
    
}
