//
//  OnboardingController.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 14/06/20.
//

import Cocoa
import WebKit

class OnboardingController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    
    private var imagesUrls = ["https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step1.pdf",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step2.png",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step3.png",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step4.gif",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step5.png"]
    
    var selectedIndex = 0 {
        didSet {
            previousButton.isHidden = (selectedIndex == 0)
            if selectedIndex == imagesUrls.count - 1 {
                //nextButton
            }
        }
    }
    
    let indicator: NSProgressIndicator = {
        let ind = NSProgressIndicator()
        ind.style = .spinning
        return ind
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        nextButton.action = #selector(gotoNext)
        nextButton.target = self
        previousButton.action = #selector(gotoPrev)
        previousButton.target = self
        previousButton.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        webView.load(URLRequest(url: URL(string: imagesUrls[selectedIndex])!))
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimation(self)
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimation(self)
        indicator.isHidden = false
    }
    
    @objc func gotoNext() {
        if selectedIndex < imagesUrls.count-1 {
            selectedIndex += 1
            webView.load(URLRequest(url: URL(string: imagesUrls[selectedIndex])!))
        }
    }
    
    @objc func gotoPrev() {
        if selectedIndex > 0 {
            selectedIndex -= 1
            webView.load(URLRequest(url: URL(string: imagesUrls[selectedIndex])!))
        }
    }
    
}
