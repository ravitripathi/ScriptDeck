//
//  AppDelegate.swift
//  StatusScript
//
//  Created by Ravi Tripathi on 31/05/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "terminal")
        }
        constructMenu()
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Run Test Script", action: #selector(self.launchShell), keyEquivalent: "R"))
        menu.addItem(NSMenuItem(title: "Add New Script", action: #selector(self.addNewScript), keyEquivalent: "A"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "Q"))
        statusItem.menu = menu
    }
    
    @objc func launchShell() {
        var command = "open ~/Documents/test.sh -a"
        if checkItermInstalled() {
            command.append(contentsOf: " iTerm")
        } else {
            command.append(contentsOf: " Terminal")
        }
        shell(command)
    }
    
    @objc func addNewScript() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "ScriptEditorController")) as? ScriptEditorController else { return }
        let windowController = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        NSApp.activate(ignoringOtherApps: true)
        windowController.showWindow(self)
    }
    
    func checkItermInstalled() -> Bool {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.arguments = ["-c", "mdfind -name \'kMDItemFSName==\"iTerm.app\"\'"]
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        
        try! task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return !output.isEmpty
    }
    
    func shell(_ command: String) {
        let task = Process()
//        let pipe = Pipe()
//        task.waitUntilExit()
//        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        try! task.run()
        
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)!
    }
}

