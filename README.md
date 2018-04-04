PopItUp
=======

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![GitHub release](https://img.shields.io/github/release/fritzgerald/PopItUp.svg)](https://github.com/fritzgerald/PopItUp/releases) [![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
 [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/PopItUp.svg)](https://cocoapods.org/pods/PopItUp)

**PopItUp** is a mini framework that add a new method to **UIViewContollers** to help you present controllers like popup and have the same visual effect has a system popup would have.

## How does it work?
PopItUp use new modal presentation style introduced in iOS 8 to present the presented view controller on top of the presenting on.

By default the popup size is determined using autolayout which means that with the right constraints you don't have to worry about the popup size. 

## Screenshot

![Exemple](https://raw.githubusercontent.com/fritzgerald/screenshots/master/PopItUp/Capture01.gif)

## Requirements
* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

## Installation
### CocoaPods
if not installed yet install cocoaPods with the following command

```
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build PopItUp

To integrate **PopItUp** into your Xcode project using CocoaPods, specify it in your Podfile:

```
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'PopItUp'
end

```

> This will install the latest version of Popup

Apply your configuration with the following command:

```
$ pod install
```

## Usage
### Presenting a popup view controller
```swift
import PopItUp


presentPopup(TestPopupViewController(), animated: true, completion: nil)
```

### Dismiss the popup

Because we use the standard iOS modal system all you have to do is call the **dismiss(animated:completion:)** method

```swift
dismiss(animated: true, completion: nil)
```

### Customize the popup presentation

The presentPopup method contains multiple parameters to customize the final result:

* ***backgroundStyle***: the background to display behind the popup. can be either a color or a blur.
* ***constraints***: List of constraints that apply to the popup.
* ***transitioning***: Transition to apply when presenting the view.
* ***autoDismiss***: true if the popup can be dismiss by a tap outside is bounds, false otherwise

```swift
presentPopup(TestPopupViewController(),
             animated: true,
             backgroundStyle: .blur(.dark), // present the popup with a blur effect has background
             constraints: [.leading(20), .width(220)], // fix leading edge and the width
             transitioning: .slide(.left), // the popup come and goes from the left side of the screen
             autoDismiss: false, // when touching outside the popup bound it is not dismissed
             completion: nil)
```



