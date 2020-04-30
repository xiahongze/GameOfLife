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
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    var gameSideWindowController = NSWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let gameSideWindowController = storyboard.instantiateController(withIdentifier: "GameSideController") as? NSWindowController {
            self.gameSideWindowController = gameSideWindowController
            self.gameSideWindowController.showWindow(nil)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showSideControllWindow(_ sender: AnyObject) {
        gameSideWindowController.showWindow(sender)
    }
    
    @IBAction func showGameWindow(_ sender: AnyObject) {
        if let win = NSApplication.shared.mainWindow?.windowController {
            win.showWindow(sender)
        }
    }
    
}
