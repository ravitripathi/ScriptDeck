//
//  StatusBarHandler.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 01/06/20.
//

import Cocoa
import Preferences

class StatusBarHandler: NSObject {
    static let shared = StatusBarHandler()
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var runInBackground = false
    var shellScripts = [ShellScriptModel]()
    var runInBackgroundItem: NSMenuItem?
    
    var preferencesStyle: Preferences.Style {
        get { .preferencesStyleFromUserDefaults() }
        set {
            newValue.storeInUserDefaults()
        }
    }
    
    lazy var preferences: [PreferencePane] = [
        GeneralPreferenceViewController(),
        AboutViewController()
    ]
    
    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: preferences,
        style: preferencesStyle,
        animated: true,
        hidesToolbarForSingleItem: false
    )
    
    func setImage() {
        if let button = statusItem.button {
            button.image = NSImage(named: "terminal")
        }
    }
    
    private func fetchAllScripts(atUrl fullUrl: URL) {
        shellScripts = [ShellScriptModel]()
        let enumerator = FileManager.default.enumerator(atPath: fullUrl.path)
        let filePaths = enumerator?.allObjects as! [String]
        //Fetches only sh files
        //let shellScriptPaths = filePaths.filter{$0.contains(".sh")}
        for scriptPath in filePaths {
            if let attributes = try? FileManager.default.attributesOfItem(atPath: fullUrl.path.appending("/\(scriptPath)")) {
                // Check if the file is executable
                if (attributes[.posixPermissions] as? NSNumber) == 0o777 {
                    shellScripts.append(ShellScriptModel(name: scriptPath, filePath: fullUrl.path.appending("/\(scriptPath)")))
                }
            }
        }
    }
    
    func constructMenu(forUrl url: URL) {
        fetchAllScripts(atUrl: url)
        let menu = NSMenu()
        for (index, script) in shellScripts.enumerated() {
            let item = NSMenuItem(title: script.name, action: #selector(self.launchShell(_:)), keyEquivalent: "")
            item.tag = index
            item.target = self
            menu.addItem(item)
        }
        menu.addItem(NSMenuItem.separator())
        runInBackgroundItem = NSMenuItem(title: "Run in background", action: #selector(shouldRunInBackground), keyEquivalent: "B")
        runInBackgroundItem?.state = runInBackground ? .on : .off
        runInBackgroundItem?.target = self
        let addScript = NSMenuItem(title: "Add New Script", action: #selector(self.addNewScript), keyEquivalent: "A")
        addScript.target = self
        menu.addItem(addScript)
        menu.addItem(runInBackgroundItem!)
        menu.addItem(NSMenuItem.separator())
        let pref = NSMenuItem(title: "Preferences", action: #selector(self.showPreferences), keyEquivalent: ",")
        pref.target = self
        menu.addItem(pref)
        
        let onboarding =  NSMenuItem(title: "Onboarding", action: #selector(self.onboard), keyEquivalent: "O")
        onboarding.target = self
        menu.addItem(onboarding)
        
        menu.addItem(NSMenuItem(title: "Quit ScriptDeck", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "Q"))
        statusItem.menu = menu
    }
    
    @objc func onboard() {
        let controller = OnboardingViewController(nibName: "OnboardingViewController", bundle: nil)
        AppDelegate.windowController.contentViewController = controller
        AppDelegate.windowController.showWindow(self)
    }
    
    @objc func showPreferences() {
        preferencesWindowController.show(preferencePane: .general)
    }
    
    @objc func shouldRunInBackground() {
        runInBackground = !runInBackground
        runInBackgroundItem?.state = runInBackground ? .on : .off
    }
    
    @objc func launchShell(_ sender: NSMenuItem) {
        let shellScript = shellScripts[sender.tag]
        
        if !self.runInBackground {
            var command = "open \(shellScript.filePath) -a "
            command.append(contentsOf: UserDefaults.standard.terminalPath)
            shell(command)
        } else {
            backgroundShell(shellScript)
        }
        
    }
    
    @objc func addNewScript() {
        NSApp.activate(ignoringOtherApps: true)
        AppDelegate.windowController.showWindow(self)
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
    
    func backgroundShell(_ shellScript: ShellScriptModel) {
        //Show notification
        let notification = NSUserNotification()
        notification.title = "Launched \(shellScript.name)"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    
        try! Process.run(URL(fileURLWithPath: "/bin/bash"), arguments: ["-c", shellScript.filePath]) { (process) in
            notification.title = "Finished \(shellScript.name)"
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
    
    
    func shell(_ command: String) {
        let task = Process()
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        try! task.run()
    }
    
}
