//
//  ScriptListController.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 21/06/20.
//

import Cocoa
import Combine

class ScriptListController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var dataArray = [ShellScriptModel]()
    //    let dataArray = ScriptDeckStore.shared.$liveShellScripts
    var observer: AnyCancellable?
    
    @IBAction func showItem(_ sender: NSButton) {
        if tableView.selectedRow < dataArray.count {
            let item = dataArray[tableView.selectedRow]
            let url = URL(fileURLWithPath: item.filePath)
            NSWorkspace.shared.open(url)
        }
    }
    
    
    @IBAction func deleteItem(_ sender: NSButton) {
        if tableView.selectedRow < dataArray.count {
            let item = dataArray[tableView.selectedRow]
            let url = URL(fileURLWithPath: item.filePath)
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.doubleAction = #selector(doubleClick)
        observer = ScriptDeckStore.shared.$liveShellScripts.sink { [weak self] (scripts) in
            self?.dataArray = scripts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CodeCreatedTableCellView"), owner: self) as? NSTableCellView {
            
            cellView.textField!.stringValue = dataArray[row].name
            return cellView
        } else {
            // Create a text field for the cell
            let textField = NSTextField()
            textField.isEditable = false
            textField.backgroundColor = NSColor.clear
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.isBordered = false
            textField.controlSize = NSControl.ControlSize.regular
            textField.stringValue = dataArray[row].name
            // Create a cell
            let newCell = NSTableCellView()
            newCell.identifier = NSUserInterfaceItemIdentifier(rawValue: "CodeCreatedTableCellView")
            newCell.addSubview(textField)
            newCell.textField = textField
            
            // Constrain the text field within the cell
            newCell.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[textField]|",
                                               options: [],
                                               metrics: nil,
                                               views: ["textField" : textField]))
            
            newCell.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|",
                                               options: [],
                                               metrics: nil,
                                               views: ["textField" : textField]))
            return newCell
        }
        
        
    }
    
    @objc func doubleClick() {
        if tableView.selectedRow < dataArray.count {
            var command = "open \(dataArray[tableView.selectedRow].filePath) -a "
            command.append(contentsOf: UserDefaults.standard.terminalPath)
            StatusBarHandler.shared.shell(command)
        }
    }
}
