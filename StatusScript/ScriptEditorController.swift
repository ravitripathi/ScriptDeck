//
//  ScriptEditorController.swift
//  StatusScript
//
//  Created by Ravi Tripathi on 31/05/20.
//

import Cocoa

class ScriptEditorController: NSViewController {
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    @IBOutlet weak var scriptTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSave(_ sender: NSButton) {
        let alert = NSAlert()
        guard !fileNameTextField.stringValue.isEmpty && !scriptTextField.stringValue.isEmpty,
            var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                alert.messageText = "Missing info"
                alert.informativeText = "The filename or the script text seems to be empty"
                alert.addButton(withTitle: "OK")
                alert.runModal()
                return
        }
        directory.appendPathComponent("StatusScriptStore")
        let fileName = fileNameTextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines).appending(".sh")
        
        var scriptText = scriptTextField.stringValue
//        var scriptText = scriptTextField.stringValue.appending("\r\n echo \"Press any key to exit\"")
//        scriptText.append("\r\n read -n 1")
        let scriptTextData = scriptText.data(using: .utf8)
        
        let url = directory.appendingPathComponent(fileName, isDirectory: false)
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: scriptTextData, attributes: nil)
            var attributes = [FileAttributeKey : Any]()
            attributes[.posixPermissions] = 0o777
            try FileManager.default.setAttributes(attributes, ofItemAtPath: url.path)
        } catch let error {
            alert.messageText = "Error!"
            alert.informativeText = error.localizedDescription
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }
        AppDelegate.windowController.close()
        alert.messageText = "Done!"
        alert.messageText = "Saved your script at \(url.absoluteString)!"
        alert.addButton(withTitle: "OK")
        alert.runModal()
        StatusBarHandler.shared.constructMenu(forUrl: directory)
    }
    //    override var representedObject: Any? {
    //        didSet {
    //        // Update the view, if already loaded.
    //        }
    //    }
    
}

