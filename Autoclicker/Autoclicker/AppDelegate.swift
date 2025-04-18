//
//  AppDelegate.swift
//  Autoclicker
//
//  Created by Niko on 2.4.2025.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let menuItem = NSApp.mainMenu?.item(withTitle: "Always on Top") {
                menuItem.isEnabled = true // Enable the menu item
            }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

