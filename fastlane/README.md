fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## Mac
### mac shipIt
```
fastlane mac shipIt
```
Ship it!
### mac buildApp
```
fastlane mac buildApp
```
Build the .app, and store it in ~/Desktop/ScriptDeckBuilds
### mac printS
```
fastlane mac printS
```
Sds
### mac bumpVersion
```
fastlane mac bumpVersion
```
Set version number, create git tag. Types: patch | minor | major
### mac releaseOnGithub
```
fastlane mac releaseOnGithub
```
Release built app on github

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
