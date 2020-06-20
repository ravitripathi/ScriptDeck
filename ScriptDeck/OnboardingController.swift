//
//  OnboardingController.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 14/06/20.
//

import Cocoa
import WebKit

class OnboardingController: NSViewController {
    
    
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    
    var texts = [
        "Hi There! Let's get started",
        "Add a new script by choosing the option from the menu. But before that, remember to grant the permission to access your Documents directory",
        "Mention the executable's name along with its extension. If nothing is provided, ScriptDeck will assume it to be .sh. On clicking save, the script is generated with the executable permissions.",
        "Click on it to execute it on Terminal. Selecting \"Run in background\" will run the script silently, and trigger macOS notifications on start and completion.",
        "That's it! A new terminal window launches with your script running in it",
        "Modify the default theme, language or application which executes your scripts from preferences. \n Enjoy using ScriptDeck!"
    ]
    
    var selectedIndex = 0 {
        didSet {
            previousButton.isHidden = (selectedIndex == 0)
            if selectedIndex == WebViewPreloader.shared.imagesUrls.count - 1 {
                nextButton.title = "Let's go!"
                nextButton.bezelColor = .systemBlue
            }
            descriptionLabel.stringValue = texts[selectedIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.action = #selector(gotoNext)
        nextButton.target = self
        previousButton.action = #selector(gotoPrev)
        previousButton.target = self
        previousButton.isHidden = true
        descriptionLabel.stringValue = texts[selectedIndex]
        set(url: WebViewPreloader.shared.imagesUrls[selectedIndex])
    }
    
    
    func set(url: URL) {
        for sub in containerView.subviews {
            sub.removeFromSuperview()
        }
        let cachedWebView = WebViewPreloader.shared.webview(for: url)
        cachedWebView.frame = containerView.bounds
        containerView.addSubview(cachedWebView)
    }
    
    @objc func gotoNext() {
        if selectedIndex < WebViewPreloader.shared.imagesUrls.count-1 {
            selectedIndex += 1
            set(url: WebViewPreloader.shared.imagesUrls[selectedIndex])
        } else {
            Onboarding.shared.close()
        }
    }
    
    @objc func gotoPrev() {
        if selectedIndex > 0 {
            selectedIndex -= 1
            set(url: WebViewPreloader.shared.imagesUrls[selectedIndex])
        }
    }
}

class Onboarding {
    
    static let shared = Onboarding()
    
    private var windowController: NSWindowController?
    
    func show() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let newWindowController = storyboard.instantiateController(withIdentifier: "OnboardingWindow") as! NSWindowController
        windowController = newWindowController
        windowController?.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
        windowController?.window?.center()
    }
    
    func close() {
        windowController?.close()
    }
}
