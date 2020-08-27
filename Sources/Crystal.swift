//
//  Crystal.swift
//  Crystal
//
//  Created by yunhao on 2020/8/8.
//  Copyright © 2020 yunhao. All rights reserved.
//

import UIKit


/// The main Crystal class. Instead of creating a `Crystal` object, you use  shared `Crystal.shared` singleton to manage themes.
///
/// In order to use Crystal, you must make `Crystal` conform to `CrystalDetermined` protocol, which is also the opportunity for
/// you to determine the concrete theme type.
///
/// Take a look at `CrystalDetermined` to learn about all the available methods and properties you can use.
public class Crystal {
    /// Returns the singleton Crystal instance.
    public static let shared = Crystal()
    
    /// The concrete theme type can only be determined when `Crystal` conforming to `CrystalDetermined`, so we use this
    /// property to store a theme of any possible types.
    var underlyingTheme: CrystalThemeType?
    
    /// A key-value map table. The key is a `CrystalCompatible` object and the value is a  `Crystalline` object.
    var mapTable = WeakKeyMapTable<AnyObject, CrystallineType>()
    
    init() {}
    
    /// Return the theme of desired type.
    ///
    /// This method should not fail at any time. It's the developer's responsibility to guarantee that there is only one concrete theme
    /// type in Crystal.
    ///
    /// - Returns: A theme of desired type.
    func desiredTheme<T: CrystalThemeType>() -> T {
        guard let underlyingTheme = underlyingTheme else {
            // if `underlyingTheme` is `nil`, initialize it with the default theme.
            let theme = T.default
            self.underlyingTheme = theme
            return theme as! T
        }
        
        return underlyingTheme as! T
    }
}

/// A protocol should only be adopted by `Crystal` class.
///
///     // Determine the concrete theme type.
///     extension Crystal: CrystalDetermined {
///         public typealias Theme: AppTheme
///     }
///
/// Although this protocol is designed for `Crystal` class, `Crystal` class does not conform to `CrystalDetermined` protocol
/// by default. When using this library, it's your responsibility to make `Crystal` class conform to `CrystalDetermined` protocol,
/// in order to determine the concrete theme type.
public protocol CrystalDetermined: Crystal {
    /// The theme type.
    associatedtype Theme: CrystalThemeType
    
    /// The current theme.
    ///
    /// Assign a new value to this property is the same as calling `setTheme(_:animated:)`.
    var theme: Theme { get set }
    
    /// Set the theme.
    /// 
    /// - Parameters:
    ///   - theme: A theme to be adopted.
    ///   - animated: `true` to animate the theme change, `false` to make the change immediate.
    func setTheme(_ theme: Theme, animated: Bool)
}

extension CrystalDetermined where Self: Crystal {
    public var theme: Theme {
        get { desiredTheme() }
        set { setTheme(newValue, animated: false) }
    }
    
    public func setTheme(_ theme: Theme, animated: Bool) {
        self.underlyingTheme = theme
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.performThemeChange(to: theme)
            }
        } else {
            performThemeChange(to: theme)
        }
    }
    
    /// Apply theme to all crystal compatible objects.
    func performThemeChange(to theme: CrystalThemeType) {
        Crystal.shared.mapTable.forEach { key, crystalline in
            guard let _ = key.object else { return }
            crystalline.reapply()
        }
    }
}

/// A type that has crystal extensions. You can use `cst` property to get extension methods.
///
///     // Make `UIView` conform to `CrystalCompatible`.
///     extension UIView: CrystalCompatible {
///         public typealias Theme: AppTheme
///     }
///
/// When conforming to `CrystalCompatible`, you have to determine the concrete theme type in the conformance.
public protocol CrystalCompatible: AnyObject {
    /// The theme type that is determined when making protocol conformance.
    associatedtype Theme: CrystalThemeType
}

extension CrystalCompatible {
    /// Crystal namespace used to expose available methods and properties.
    public var cst: Crystalline<Self, Theme> {
        // Return the exist object.
        if let crystal = Crystal.shared.mapTable[self] as? Crystalline<Self, Theme> {
            return crystal
        }
        // Create and return a new `Crystalline` object.
        let crystal = Crystalline<Self, Theme>(self)
        Crystal.shared.mapTable[self] = crystal
        return crystal
    }
}

