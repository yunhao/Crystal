//
//  Extensions.swift
//  Crystal
//
//  Created by yunhao on 2020/8/11.
//  Copyright © 2020 yunhao. All rights reserved.
//

import UIKit
import Crystal

// The app theme.
public struct AppTheme: CrystalThemeType, Equatable {
    
    var text: String
    
    var textColor: UIColor?
    
    var backgroundColor: UIColor?
    
    var borderColor: UIColor?
    
    static var light: AppTheme {
        return AppTheme(
            text: "light",
            textColor: .black,
            backgroundColor: .white,
            borderColor: .black
        )
    }
    
    static var dark: AppTheme {
        return AppTheme(
            text: "dark",
            textColor: .white,
            backgroundColor: .black,
            borderColor: .white
        )
    }
    
    /// Change this value to triger `default` property change.
    static var underlyingDefaultTheme: Self = .dark
    
    public static var `default`: CrystalThemeType {
        return Self.underlyingDefaultTheme
    }
}

// Determine the concrete theme type.
extension Crystal: CrystalDetermined {
    public typealias Theme = AppTheme
}

// Make compatible.
extension UIView: CrystalCompatible {
    public typealias Theme = AppTheme
}
