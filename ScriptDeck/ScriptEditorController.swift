//
//  ScriptEditorController.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 31/05/20.
//

import Cocoa
import Highlightr

class ScriptEditorController: NSViewController {
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    var scriptTextField: NSTextView!
    
    @IBOutlet weak var saveButton: NSButton!
    let textStorage = CodeAttributedString()
    var languageObserver: NSKeyValueObservation?
    var themeObserver: NSKeyValueObservation?
    @IBOutlet weak var themeDropDown: NSPopUpButton!
    @IBOutlet weak var languageDropDown: NSPopUpButton!
    @IBOutlet weak var scriptContentTitleLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        scriptTextField = NSTextView(frame: .zero, textContainer: textContainer)
        scriptTextField.translatesAutoresizingMaskIntoConstraints = false
        scriptTextField.appearance = NSAppearance(named: .aqua)
        scriptTextField.backgroundColor = textStorage.highlightr.theme.themeBackgroundColor
        self.view.addSubview(scriptTextField)
        
        
        scriptTextField.topAnchor.constraint(equalTo: scriptContentTitleLabel.bottomAnchor, constant: 10.0).isActive = true
        scriptTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        scriptTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        scriptTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16.0).isActive = true
        
        setupDropDowns()
        
        languageDropDown.action = #selector(self.didSelectLanguage(_:))
        languageDropDown.target = self
        
        themeDropDown.action = #selector(self.didSelectTheme(_:))
        themeDropDown.target = self
        
        languageObserver = UserDefaults.standard.observe(\.language, options: [.new,.old], changeHandler: { [weak self] (object, change) in
            self?.setPreferredValues()
        })
        
        themeObserver = UserDefaults.standard.observe(\.theme, options: [.new,.old], changeHandler: { [weak self] (object, change) in
            self?.setPreferredValues()
        })
    }
    
    func setupDropDowns() {
        for theme in self.textStorage.highlightr.availableThemes() {
            themeDropDown.addItem(withTitle: theme)
        }
        for language in self.textStorage.highlightr.supportedLanguages() {
            languageDropDown.addItem(withTitle: language)
        }
        setPreferredValues()
    }
    
    func setPreferredValues() {
        if let bashIndex = self.textStorage.highlightr.supportedLanguages().firstIndex(where: { (string) -> Bool in
            string == UserDefaults.standard.language
        }) {
            languageDropDown.selectItem(at: bashIndex)
        }
        
        if let themeIndex = self.textStorage.highlightr.availableThemes().firstIndex(where: { (string) -> Bool in
            string == UserDefaults.standard.theme
        }) {
            themeDropDown.selectItem(at: themeIndex)
        }
        textStorage.language = UserDefaults.standard.language
        textStorage.highlightr.setTheme(to: UserDefaults.standard.theme)
        scriptTextField.backgroundColor = textStorage.highlightr.theme.themeBackgroundColor
    }
    
    @objc func didSelectLanguage(_ sender: NSPopUpButton) {
        if let langString = sender.selectedItem?.title {
            textStorage.language = langString
            UserDefaults.standard.language = langString
        }
    }
    
    @objc func didSelectTheme(_ sender: NSPopUpButton) {
        if let themeString = sender.selectedItem?.title {
            textStorage.highlightr.setTheme(to: themeString)
            scriptTextField.backgroundColor = textStorage.highlightr.theme.themeBackgroundColor
            UserDefaults.standard.theme = themeString
        }
    }
    
    @IBAction func didTapSave(_ sender: NSButton) {
        let alert = NSAlert()
        guard !fileNameTextField.stringValue.isEmpty && !scriptTextField.string.isEmpty,
            var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                alert.messageText = "Missing info"
                alert.informativeText = "The filename or the script text seems to be empty"
                alert.addButton(withTitle: "OK")
                alert.runModal()
                return
        }
        directory.appendPathComponent("ScriptDeckStore")
        var fileName = fileNameTextField.stringValue.filter { !$0.isWhitespace }
        
        // Check if extension, else .sh
        if (NSURL(fileURLWithPath: fileName).pathExtension ?? "").isEmpty {
            fileName.append(contentsOf: ".sh")
        }
        let scriptText = scriptTextField.string
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
    }
    //    override var representedObject: Any? {
    //        didSet {
    //        // Update the view, if already loaded.
    //        }
    //    }
    
    deinit {
        languageObserver?.invalidate()
        themeObserver?.invalidate()
    }
    
}

