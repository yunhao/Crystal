<p align="center">
    <img src="https://raw.githubusercontent.com/yunhao/Crystal/master/Resources/logo.png" alt="Crystal" title="Crystal" width="500"/>
</p>

<p align="center">
    <a href="https://github.com/yunhao/Crystal/actions?query=workflow%3Abuild">
        <img src="https://github.com/yunhao/Crystal/workflows/build/badge.svg?branch=master">
    </a>
    <a href="https://cocoapods.org/pods/Crystal">
        <img src="https://img.shields.io/cocoapods/v/Crystal.svg">
    </a>
    <a href="https://swift.org/package-manager/">
        <img alt="SPM support" src="https://img.shields.io/badge/SwiftPM-supported-FF6255">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-yellow.svg"/>
    </a>
    <br/>
    <a href="https://github.com/yunhao/Crystal/blob/master/LICENSE">
        <img alt="GitHub license" src="https://img.shields.io/github/license/yunhao/Crystal">
    </a>
    <img alt="Cocoapods platforms" src="https://img.shields.io/cocoapods/p/Crystal">
</p>

---

Crystal is a lightweight and intuitive theme manager for iOS. It takes advantage of Swift’s features to provide an easy-to-use interface. With Crystal, you can integrate themes into your app with confidence and flexibility.

<p align="center">
<img src="https://raw.githubusercontent.com/yunhao/Crystal/master/Resources/crystal-example.gif" alt="Crystal" title="Crystal" width="150"/>
</p>

## Feature

- **Flexible**: Crystal is compitible with any object, not just built-in UI components. You can use Crystal anywhere.
- **Friendly**: Apply themes in a way you're familiar with, and no additional property APIs will make you confused and distracted.
- **Simple**: Adding a theme is as simple as creating an instance. It's easy to maintain your themes with Crystal.
- **Type Safe**: Take full advantage of swift's type safety. Apply your theme with confidence and benefit from compile-time check.

## Getting Started

* [Usage](#Usage)
* [Requirements](#Requirements)
* [Installation](#Installation)
* [API Documentation](https://yunhao.github.io/Crystal)
* [Example App](https://github.com/yunhao/Crystal/blob/master/Example)

## Usage

To use Crystal, there are three steps: [Define Theme Type](#Define-Theme-Type) -> [Make Compatible](#Make-Compatible) -> [Apply Theme](#Apply-Theme)

### Setp 1 - Define Theme Type

You can introduce your theme type by making `class` or `struct` conform to `CrystalThemeType` protocol. With this protocol, you have to implement a static property to return the entry theme.

```swift
public struct AppTheme {
    var textColor: UIColor
    var backgroundColor: UIColor
}

extension AppTheme: CrystalThemeType {
    static var light: AppTheme {
        return AppTheme(
            textColor: .black,
            backgroundColor: .white
        )
    }

    static var dark: AppTheme {
        return AppTheme(
            textColor: .white,
            backgroundColor: .black
        )
    }

    // Return the entry theme.
    public static var entry: CrystalThemeType {
        return Self.light
    }
}
```

### Setp 2 - Make Compatible

In order to tell Crystal about your theme type:
- Make `Crystal` conform to `CrystalDetermined`. 
- Make any type conform to `CrystalCompatible` according to your needs.

Use `typealias` to determine the concrete theme type.

```swift
// Required. Determine the concrete theme type.
extension Crystal: CrystalDetermined {
    public typealias Theme = AppTheme
}

// Optional. Make any type compatible as you need.
extension UIView: CrystalCompatible {
    public typealias Theme = AppTheme
}
extension UIBarButtonItem: CrystalCompatible {
    public typealias Theme = AppTheme
}
```

Any object that conforms to `CrystalCompatible` protocol has a `cst` namespace for exposing Crystal methods.


### Step 3 - Apply Theme

Use the `apply(_:)` method to apply theme and you can do whatever you want in the closure:

```swift
// Apply theme to a button.
doneButton.cst.apply { button, theme in
    button.setTitleColor(theme.textColor, for: .normal)
}
// Apply theme to a custom view.
cardView.cst.apply { card, theme in 
    card.backgroundColor = theme.backgroundColor
    card.titleColor = theme.textColor
}
// Shorthand argument names.
imageView.cst.apply { $0.tintColor = $1.textColor }
```

Assign a new value to `Crystal.shared.theme` to change theme:

```swift
// Change theme.
Crystal.shared.theme = .dark
```

## Requirements

- Swift 5.0+
- iOS 10.0+

## Installation

### CocoaPods

When using [CocoaPods](https://cocoapods.org), add the following to your `Podfile`:

```ruby
pod 'Crystal', '~> 1.1'
```

### Carthage

For [Carthage](https://github.com/Carthage/Carthage), add the following to your `Cartfile`:

```ruby
github "yunhao/Crystal"
```

### Swift Package Manager

Add the following to the dependencies section of your `Package.swift` file:

```swift
.package(url: "https://github.com/yunhao/Crystal.git", from: "1.1.0")
```

## Contribution

Pull requests, bug reports and feature requests are welcome.

## License

Crystal is released under the [MIT License](https://github.com/yunhao/Crystal-Test/blob/master/LICENSE).