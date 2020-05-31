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
        guard !fileNameTextField.stringValue.isEmpty && !scriptTextField.stringValue.isEmpty else {
            let alert = NSAlert()
            alert.messageText = "Missing info"
            alert.informativeText = "The filename or the script text seems to be empty"
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }
        let fileName = fileNameTextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let scriptText = scriptTextField.stringValue
        
    }
    //    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }


}



