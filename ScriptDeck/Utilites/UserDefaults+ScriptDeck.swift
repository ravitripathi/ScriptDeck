//
//  UserDefaults+ScriptDeck.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 20/06/20.
//

import Foundation

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
    
    var firstTimeLaunch: Bool {
        get {
            return bool(forKey: "firstTime")
        }
        set {
            set(newValue, forKey: "firstTime")
        }
    }
}
