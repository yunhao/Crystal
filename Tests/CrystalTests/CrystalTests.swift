//
//  CrystalTests.swift
//  CrystalTests
//
//  Created by yunhao on 2020/8/8.
//  Copyright © 2020 yunhao. All rights reserved.
//

import XCTest
@testable import Crystal

class CrystalTests: XCTestCase {
    
    var textLabel: UILabel!
    
    override func setUp() {
        super.setUp()
        textLabel = UILabel()
    }

    override func tearDown() {
        super.tearDown()
        textLabel = nil
        // Restore default theme.
        Crystal.shared.underlyingTheme = nil
        AppTheme.underlyingDefaultTheme = .light
    }
    
    func testDefaultTheme() throws {
        // The `default` property must be the determined concrete theme type.
        let defaultTheme = try XCTUnwrap(AppTheme.default as? Crystal.Theme)
        // Crystal uses the default theme automatically.
        XCTAssertEqual(Crystal.shared.theme, defaultTheme)
    }
    
    func testDefaultThemeChangeNoEffect() {
        // Apply default theme.
        textLabel.cst.apply {
            $0.backgroundColor = $1.backgroundColor
        }
        // Change default theme and reapply.
        AppTheme.underlyingDefaultTheme = .dark
        textLabel.cst.reapply()
        
        XCTAssertEqual(textLabel.backgroundColor, AppTheme.light.backgroundColor)
    }
    
    func testSetTheme() {
        Crystal.shared.theme = .light
        textLabel.cst.apply {
            $0.backgroundColor = $1.backgroundColor
        }
        // Set a different theme.
        Crystal.shared.setTheme(.dark, animated: false)
        XCTAssertEqual(textLabel.backgroundColor, AppTheme.dark.backgroundColor)
    }
    
    func testApplyClosuresWithTheSameKeyMultipleTimes() {
        let total = 10
        for _ in 0..<total {
            textLabel.cst.apply {
                $0.backgroundColor = $1.backgroundColor
            }
        }
        // Overwrite occurs.
        XCTAssertEqual(textLabel.cst.closures.count, 1)
    }
    
    func testApplyClosuresWithDifferentKey() {
        textLabel.cst.apply {
            $0.backgroundColor = $1.backgroundColor
        }
        textLabel.cst.apply(key: "text") {
            $0.text = $1.text
            $0.textColor = $1.textColor
        }
        textLabel.cst.apply(key: "border") {
            $0.layer.borderWidth = 2.0
            $0.layer.borderColor = $1.borderColor?.cgColor
        }
        // Three closures with different keys.
        XCTAssertEqual(textLabel.cst.closures.count, 3)
    }
    
    func testStrongReferenceCycles() {
        var labels: [UILabel?] = []
        let total = 10
        
        for _ in 0..<total {
            let label = UILabel()
            label.cst.apply {
                $0.backgroundColor = $1.backgroundColor
            }
            labels.append(label)
        }
        
        XCTAssertEqual(Crystal.shared.mapTable.count, total)
        
        for i in 0..<total {
            labels[i] = nil
        }
        
        // Map table elements will be removed automatically when the object is deallocated.
        XCTAssertEqual(Crystal.shared.mapTable.count, 0)
    }
}
