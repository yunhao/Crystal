//
//  Crystalline.swift
//  Crystal
//
//  Created by yunhao on 2020/8/10.
//  Copyright © 2020 yunhao. All rights reserved.
//

import Foundation

protocol CrystallineType: AnyObject {
    /// Reapply the theme to the object.
    func reapply()
}

/// Wrapper for crystal compatible types.
public class Crystalline<Target: AnyObject, Theme: CrystalThemeType>: CrystallineType {
    /// The target object where we want to apply theme.
    private weak var target: Target?
    
    /// Apply the theme to the target.
    var closures: [String: ((Target, Theme) -> Void)] = [:]
    
    /// The current theme.
    private var theme: Theme {
        return Crystal.shared.desiredTheme()
    }
    
    init(_ target: Target) {
        self.target = target
    }
    
    /// Apply the theme to the target object in a closure.
    ///
    /// If you call this method multiple times on the same object, only the last call will take effect.
    ///
    /// - Parameters:
    ///   - closure: A clourse where you apply the theme.
    ///   - target: The target object you want to apply the theme to.
    ///   - theme: The theme.
    public func apply(_ closure: @escaping (_ target: Target, _ theme: Theme) -> Void) {
        apply(key: "_default", closure)
    }
    
    /// Apply the theme to the target object in a closure.
    ///
    /// If you call this method multiple times with the same key, only the last one will take effect.
    ///
    /// - Parameters:
    ///   - key: An unique key used to distinguish different closures.
    ///   - closure: A clourse where you apply the theme.
    ///   - target: The target object you want to apply the theme to.
    ///   - theme: The theme.
    public func apply(key: String, _ closure: @escaping (_ target: Target, _ theme: Theme) -> Void) {
        guard let target = target else { return }
        closures[key] = closure
        closure(target, theme)
    }
    
    func reapply() {
        let theme = self.theme
        for closure in closures.values {
            guard let target = target else { continue }
            closure(target, theme)
        }
    }
}
