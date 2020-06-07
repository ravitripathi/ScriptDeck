import Cocoa
import Preferences
import Highlightr

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    let codeAS = CodeAttributedString()
    var languageObserver: NSKeyValueObservation?
    var themeObserver: NSKeyValueObservation?
    override var nibName: NSNib.Name? { "GeneralPreferenceViewController" }
    
    @IBOutlet weak var languagePopUp: NSPopUpButton!
    @IBOutlet weak var themePopUp: NSPopUpButton!
    
    
    @IBOutlet weak var defaultTerminalButton: NSButton!
    @IBAction func pickDefaultTerminal(_ sender: NSButton) {
        if let url = NSOpenPanel().selectUrl {
            UserDefaults.standard.terminalPath = url.path
            sender.title = url.lastPathComponent
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTerminalButton.title = UserDefaults.standard.terminalPath
        for theme in codeAS.highlightr.availableThemes() {
            themePopUp.addItem(withTitle: theme)
        }
        for language in codeAS.highlightr.supportedLanguages() {
            languagePopUp.addItem(withTitle: language)
        }
        
        self.setPreferredValues()
        languagePopUp.action = #selector(self.didSelectLanguage(_:))
        languagePopUp.target = self
        
        themePopUp.action = #selector(self.didSelectTheme(_:))
        themePopUp.target = self
        
        languageObserver = UserDefaults.standard.observe(\.language, options: [.new,.old], changeHandler: { [weak self] (object, change) in
            self?.setPreferredValues()
        })
        
        themeObserver = UserDefaults.standard.observe(\.theme, options: [.new,.old], changeHandler: { [weak self] (object, change) in
            self?.setPreferredValues()
        })
    }
    
    func setPreferredValues() {
        if let bashIndex = codeAS.highlightr.supportedLanguages().firstIndex(where: { (string) -> Bool in
            string == UserDefaults.standard.language
        }) {
            languagePopUp.selectItem(at: bashIndex)
        }
        
        if let themeIndex = codeAS.highlightr.availableThemes().firstIndex(where: { (string) -> Bool in
            string == UserDefaults.standard.theme
        }) {
            themePopUp.selectItem(at: themeIndex)
        }
    }
    
    @objc func didSelectLanguage(_ sender: NSPopUpButton) {
        if let langString = sender.selectedItem?.title {
            UserDefaults.standard.language = langString
        }
    }
    
    @objc func didSelectTheme(_ sender: NSPopUpButton) {
        if let themeString = sender.selectedItem?.title {
            UserDefaults.standard.theme = themeString
        }
    }
    
    deinit {
        languageObserver?.invalidate()
        themeObserver?.invalidate()
    }
}
