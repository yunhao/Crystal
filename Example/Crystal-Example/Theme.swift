//
//  Theme.swift
//  Crystal-Example
//
//  Created by yunhao on 2020/8/13.
//  Copyright © 2020 yunhao. All rights reserved.
//

import UIKit
import Crystal

// The app theme.
public struct AppTheme: CrystalThemeType {
    
    var name: String
    
    // Text
    
    var titleColor: UIColor = .darkText
    
    var labelColor: UIColor = .lightMode(.label)
    
    var secondayLabelColor: UIColor = .lightMode(.secondaryLabel)
    
    var textColor: UIColor = .darkText
    
    // Switch Button
    
    var switchOnTintColor: UIColor = UIColor.systemPink.withAlphaComponent(0.8)
    
    // Navigation Bar
    
    var barStyle: UIBarStyle = .default
    
    var barTintColor: UIColor = .lightMode(.systemBackground)
    
    var barButtonItemTintColor: UIColor = .lightMode(.label)
    
    // Others
    
    var backgroundColor: UIColor = .lightMode(.systemBackground)
}

extension AppTheme {
    public static var entry: CrystalThemeType {
        return Self.light
    }
    
    static var light: AppTheme {
        return AppTheme(
            name: "light"
        )
    }
    
    static var dark: AppTheme {
        return AppTheme(
            name: "dark",
            titleColor: .darkMode(.label),
            labelColor: .darkMode(.label),
            secondayLabelColor: .darkMode(.secondaryLabel),
            textColor: .lightText,
            switchOnTintColor: .systemGreen,
            barStyle: .black,
            barTintColor: .darkMode(.systemBackground),
            barButtonItemTintColor: .darkMode(.label),
            backgroundColor: .darkMode(.systemBackground)
        )
    }
    
    static var sea: AppTheme {
        return AppTheme(
            name: "sea",
            titleColor: .systemBlue,
            switchOnTintColor: .systemBlue,
            barTintColor: .systemBlue,
            barButtonItemTintColor: .white
        )
    }
    
    static var forest: AppTheme {
        return AppTheme(
            name: "forest",
            titleColor: .systemGreen,
            switchOnTintColor: .systemGreen,
            barTintColor: .systemGreen,
            barButtonItemTintColor: .white
        )
    }
}

// Helper extension.
extension UIColor {
    
    static func darkMode(_ color: UIColor) -> UIColor {
        return color.resolvedColor(with: .dark)
    }
    
    static func lightMode(_ color: UIColor) -> UIColor {
        return color.resolvedColor(with: .light)
    }
    
    func resolvedColor(with uiStyle: UIUserInterfaceStyle) -> UIColor {
        let darkModelTrait = UITraitCollection(traitsFrom: [
            .current,
            UITraitCollection(userInterfaceStyle: uiStyle)
        ])
        return self.resolvedColor(with: darkModelTrait)
    }
    
}

// Determine the concrete theme type.
extension Crystal: CrystalDetermined {
    public typealias Theme = AppTheme
}

// Make compatible.
extension UIViewController: CrystalCompatible {
    public typealias Theme = AppTheme
}

extension UIView: CrystalCompatible {
    public typealias Theme = AppTheme
}

extension UIBarButtonItem: CrystalCompatible {
    public typealias Theme = AppTheme
}
