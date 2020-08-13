//
//  Crystalline.swift
//  Crystal
//
//  Created by yunhao on 2020/8/10.
//  Copyright © 2020 yunhao. All rights reserved.
//

import Foundation

protocol CrystallineType {
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
    
    /// Apply the theme to the target object with a closure.
    /// - Parameters:
    ///   - key: An unique key used to distinguish different closures.
    ///   - closure: A clourse indicates how to apply theme.
    ///   - target: The target object.
    ///   - theme: The theme.
    ///
    /// If you call this method multiple times with the same key, only the last one will take effect.
    public func apply(key: String? = nil, _ closure: @escaping (_ target: Target, _ theme: Theme) -> Void) {
        guard let target = target else { return }
        
        let key = key ?? "_default"
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
