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
    
    static var windowController: NSWindowController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        return windowController
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        StatusBarHandler.shared.setImage()
        WebViewPreloader.shared.preloadImages()
        ScriptDeckStore.shared.setupFolder()
        ScriptDeckStore.shared.setFSObserver()
        StatusBarHandler.shared.setupFileSystemListener()

        if !UserDefaults.standard.firstTimeLaunch {
            UserDefaults.standard.firstTimeLaunch = true
            Onboarding.shared.show()
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
