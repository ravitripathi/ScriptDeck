![ScriptDeck](https://raw.githubusercontent.com/ravitripathi/ScriptDeck/master/ScriptDeckLogo.png)

<H4 align="center">
A macOS status bar app for adding and launching executable scripts
</H4>


<p align="center">
<a href="https://developer.apple.com/swift"><img alt="Swift5" src="https://img.shields.io/badge/language-Swift5-orange.svg"/></a>
<a href="https://github.com/ravitripathi/ScriptDeck/releases"><img alt="Swift5" src="https://img.shields.io/github/v/tag/ravitripathi/ScriptDeck?label=release"/></a>
<a href="https://img.shields.io/github/downloads/ravitripathi/ScriptDeck/total?color=green"><img src="https://img.shields.io/github/downloads/ravitripathi/ScriptDeck/total?color=green"/></a>
<img src="https://img.shields.io/badge/platform-macOS-green"/>
</p>

Got scripts scattered across your mac? Tired of changing directories and hunting for that one shell script? ScriptDeck simplifies managing scripts by providing a single place to launch them from, and maintaining a single directory for storing them.

# Installation
Add the [tools](https://github.com/ravitripathi/homebrew-tools) homebrew tap and install

```
brew tap ravitripathi/tools
brew cask install scriptdeck
```

# Screenshots
<img src="https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step1.png" width="30%"></img> <img src="https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step2.png" width="30%"></img> <img src="https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step3.png" width="30%"></img> <img src="https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step4.gif" width="30%"></img> <img src="https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step5.png" width="30%"></img> <img src="https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step6.png" width="30%"></img> 

# Features
- Add shell scripts (or any other executable script) directly from your status bar
- Scripts are saved in `~/Documents/ScriptDeckStore` with executable permissions.
- Background mode runs the script without launching a terminal instance. macOS notifications are triggered at the start and completion of your script.
- Ships with a editor with syntax highlighting, powered by [Highlightr](https://github.com/raspu/Highlightr)
- ScriptDeck monitors files in ~/Documents/ScriptDeckStore and updates automatically when a file is added/removed from the folder.
- Manage your existing scrips from the `Manage Scripts` option in the menu.
- Scripts are launched with the default Terminal.app. If you prefer iTerm or any other terminal app, select it in the `Preferences` window.

# Existing scripts

For launching your existing shell scripts present in other directories, use the standard `source` command.

`source /path/to/your/script`

# Contributing

File feature requests, bugs and fixes under [Issues](https://github.com/ravitripathi/ScriptDeck/issues).

After cloning the repo, run `carthage bootstrap --platform macos` to make sure you have the `Highlighter.framework` and its corresponding dsym file.

Shoutout to [Vaibhav](https://github.com/vshelke) for suggesting this great name!

# License

ScriptDeck is released under the MIT license. [See LICENSE](https://github.com/ravitripathi/ScriptDeck/blob/master/LICENSE) for details.
