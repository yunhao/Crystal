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
///         public static var entry: CrystalThemeType {
///             return Self.light
///         }
///     }
///
/// Conform to this protocol to make your concrete theme type. You should only create one concrete theme type to satisfy Crystal,
/// otherwise some inconsistent errors may occur.
public protocol CrystalThemeType {
    /// The theme that Crystal applies to your app when the app launches.
    ///
    /// In practice, this property should represent the user's preferred theme. Crystal applies this theme to the app when the app launches.
    /// If you want to apply a different theme to the app later, assign the theme to `Crystal.shared.theme` property or call
    /// `Crystal.shared.setTheme(_:animated:)` method.
    static var entry: CrystalThemeType { get }
}
