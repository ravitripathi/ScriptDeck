//
//  ScriptDeckStore.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 20/06/20.
//
//  Responsibilities:
//  - Setup the ScriptDeckStore folder
//  - Keep the URL handy
//  - Observe Changes

import Foundation

class ScriptDeckStore: NSObject {
    
    static let shared = ScriptDeckStore()
    
    @Published
    var liveShellScripts = [ShellScriptModel]()
    var observer: DirectoryObserver?
    
    var url : URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("ScriptDeckStore")
    }()
    
    private override init() {
        super.init()
        fetchAllScript()
    }
    
    func fetchAllScript() {
        let enumerator = FileManager.default.enumerator(atPath: self.url.path)
        let filePaths = enumerator?.allObjects as! [String]
        
        var tempContainer = [ShellScriptModel]()
        
        for scriptPath in filePaths {
            if let attributes = try? FileManager.default.attributesOfItem(atPath: self.url.path.appending("/\(scriptPath)")) {
                // Check if the file is executable
                if (attributes[.posixPermissions] as? NSNumber) == 0o777 {
                    tempContainer.append(ShellScriptModel(name: scriptPath, filePath: self.url.path.appending("/\(scriptPath)")))
                }
            }
        }
        liveShellScripts = tempContainer
    }
    
    func setupFolder() {
        var isDirectory: ObjCBool = true
        do {
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            }
        } catch {
            print("Could not create folder. Exiting")
            abort()
        }
    }
    
    func setFSObserver() {
       observer = DirectoryObserver(URL: url, block: fetchAllScript)
    }
    
    
}


class DirectoryObserver {
    
    private let fileDescriptor: CInt
    private let source: DispatchSourceProtocol
    
    deinit {
        
        self.source.cancel()
        close(fileDescriptor)
    }
    
    init(URL: URL, block: @escaping ()->Void) {
        
        self.fileDescriptor = open(URL.path, O_EVTONLY)
        self.source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: self.fileDescriptor, eventMask: .all, queue: DispatchQueue.global())
        self.source.setEventHandler {
            block()
        }
        self.source.resume()
    }
    
}
