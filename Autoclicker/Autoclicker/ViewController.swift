//
//  ViewController.swift
//  Autoclicker
//
//  Created by Niko on 2.4.2025.
//

import Cocoa
import CoreGraphics

class ViewController: NSViewController {
    
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var intervalTextField: NSTextField!

    var timer: Timer?
    var clickInterval: Double = 0.0
    var isClicking = false // Track if auto-clicking is enabled
    var globalShortcut: NSEvent.ModifierFlags = [.command, .shift] // Default shortcut
    var hotkeyPressed: Bool = false // Track if hotkey is pressed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request Accessibility permissions
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        requestAccessibilityPermission()
        
        if !accessEnabled {
            print("⚠️ Accessibility permissions are required!")
            requestAccessibilityPermission()
        }
    }

    // Action for the Start Button
    @IBAction func startClicking(_ sender: NSButton) {
        print("✅ Auto-clicking started!")

        // Get the interval value from the text field
        let intervalText = intervalTextField.stringValue
        
        // Convert the intervalText to Double, if possible
        if let interval = Double(intervalText), interval > 0 {
            clickInterval = interval / 1000 // Convert milliseconds to seconds

            // Start clicking
            startAutoClicking()

            // Disable start button and enable stop button
            startButton.isEnabled = false
            stopButton.isEnabled = true
            isClicking = true
        } else {
            let alert = NSAlert()
            alert.messageText = "Invalid click interval"
            alert.informativeText = "Input atleast 1 milliseconds."
            alert.alertStyle = .critical // Display an error-style alert
            alert.addButton(withTitle: "OK") // Button to dismiss the alert
                    
            alert.runModal() // Display the alert
        }
    }

    // Action for the Stop Button
    @IBAction func stopClicking(_ sender: NSButton) {
        print("⏹ Auto-clicking stopped!")

        // Stop clicking
        stopAutoClicking()

        // Enable start button and disable stop button
        startButton.isEnabled = true
        stopButton.isEnabled = false
        isClicking = false
    }
    
    func startAutoClicking() {
        print("⏳ Timer started with interval: \(clickInterval) seconds")

        // Start by clicking at the current mouse location
        clickMouse()

        // Set up the timer to click continuously
        timer = Timer.scheduledTimer(withTimeInterval: clickInterval, repeats: true) { _ in
            // Get current mouse position before every click
            print("🖱 Clicking at current mouse location...")
            self.clickMouse()  // Click at the current position
        }
    }

    func stopAutoClicking() {
        timer?.invalidate()
        timer = nil
    }
    
    func clickMouse() {
        // Get the current mouse location
        let mouseLocation = NSEvent.mouseLocation

        // Convert the mouse position from bottom-left to top-left (required by CGEvent)
        if let screenHeight = NSScreen.main?.frame.height {
            let correctedY = screenHeight - mouseLocation.y
            let correctedPoint = CGPoint(x: mouseLocation.x, y: correctedY)

            let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: correctedPoint, mouseButton: .left)
            let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: correctedPoint, mouseButton: .left)

            mouseDown?.post(tap: .cghidEventTap)
            mouseUp?.post(tap: .cghidEventTap)

            print("✅ Clicked at \(correctedPoint)")
        } else {
            print("❌ Failed to get screen height!")
        }
    }

    // Request Accessibility permissions
    func requestAccessibilityPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("⚠️ Accessibility permissions are required! Please enable them in System Settings.")
        } else {
            print("✅ Accessibility permissions granted!")
        }
    }

}
