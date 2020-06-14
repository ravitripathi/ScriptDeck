//
//  AppDelegate.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 31/05/20.
//

import Cocoa
import Preferences

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    static let imagesUrls = [URL(string:"https://github.com/ravitripathi/ScriptDeck/raw/master/ScriptDeckLogo.png")!,
                             URL(string: "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step1.png")!,
                             URL(string:"https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step2.png")!,
                             URL(string:"https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step3.png")!,
                             URL(string:"https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step4.gif")!,
                             URL(string:"https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step5.png")!]
    
    static var windowController: NSWindowController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        return windowController
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        StatusBarHandler.shared.setImage()
        WebViewPreloader.shared.preload(urls: AppDelegate.imagesUrls)
        
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var isDirectory: ObjCBool = true
            let fullUrl = url.appendingPathComponent("ScriptDeckStore")
            if !FileManager.default.fileExists(atPath: fullUrl.path, isDirectory: &isDirectory) {
                try? FileManager.default.createDirectory(at: fullUrl, withIntermediateDirectories: false, attributes: nil)
            }
            StatusBarHandler.shared.constructMenu(forUrl: fullUrl)
        }
        
    }
}


extension NSOpenPanel {
    var selectUrl: URL? {
        title = "Select Your Terminal App"
        allowsMultipleSelection = false
        canChooseDirectories = false
        canChooseFiles = true
        canCreateDirectories = false
        //        allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]  // to allow only images, just comment out this line to allow any file type to be selected
        return runModal() == .OK ? urls.first : nil
    }
    //    var selectUrls: [URL]? {
    //        title = "Select Images"
    //        allowsMultipleSelection = true
    //        canChooseDirectories = false
    //        canChooseFiles = true
    //        canCreateDirectories = false
    //        allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]  // to allow only images, just comment out this line to allow any file type to be selected
    //        return runModal() == .OK ? urls : nil
    //    }
}

extension Preferences.PaneIdentifier {
    static let general = Self("general")
    static let about = Self("about")
}

extension UserDefaults
{
    @objc dynamic var language: String
        {
        get {
            return string(forKey: "language") ?? "bash"
        }
        set {
            set(newValue, forKey: "language")
        }
    }
    
    @objc dynamic var theme: String
        {
        get {
            return string(forKey: "theme") ?? "solarized-dark"
        }
        set {
            set(newValue, forKey: "theme")
        }
    }
    
    var terminalPath: String {
        get {
            return string(forKey: "terminalPath") ?? "Terminal"
        }
        set {
            set(newValue, forKey: "terminalPath")
        }
    }
}
