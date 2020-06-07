//
//  AboutViewController.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 08/06/20.
//

import Cocoa
import Preferences

final class AboutViewController: NSViewController, PreferencePane {
    
    @IBOutlet weak var repoURLField: NSTextField!
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.about
    let preferencePaneTitle = "About"
    let toolbarItemIcon = NSImage(named: NSImage.infoName)!
    override var nibName: NSNib.Name? { "AboutViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: NSColor.linkColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as AnyObject,
            NSAttributedString.Key.link : NSURL(string: "https://github.com/ravitripathi/ScriptDeck")!
        ]
        repoURLField.alignment = .center
        repoURLField.attributedStringValue = NSAttributedString(string: "https://github.com/ravitripathi/ScriptDeck", attributes: attributes)
        
    }
}
