//
//  CrystalThemeType.swift
//  Crystal
//
//  Created by yunhao on 2020/8/10.
//  Copyright © 2020 yunhao. All rights reserved.
//

import Foundation

/// Represent a theme type.
///
///     // A concrete theme type.
///     struct AppTheme: CrystalThemeType {
///         var textColor: UIColor?
///
///         static var light: AppTheme {
///             return AppTheme(textColor: .blue)
///         }
///
///         public static var `default`: CrystalThemeType {
///             return Self.light
///         }
///     }
///
/// Conform to this protocol to make your concrete theme type. You should only create one concrete theme type to satisfy Crystal,
/// otherwise some inconsistent errors may occur.
public protocol CrystalThemeType {
    /// The default theme.
    ///
    /// Crystal uses this property to determine the default theme when you neither assign a theme to `Crystal.shared.theme`
    /// property nor call `setTheme(_:animated:)` method. This property will only be called once when the first time you call
    /// `apply(key:_:)` method. After that, changing the value of this property has no effect on Crystal. If you want to apply a
    /// different theme to the app, use `Crystal.shared.setTheme(_:animated:)` instead.
    static var `default`: CrystalThemeType { get }
}
