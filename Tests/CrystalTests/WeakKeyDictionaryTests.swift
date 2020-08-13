//
//  WeakKeyDictionaryTests.swift
//  CrystalTests
//
//  Created by yunhao on 2020/8/13.
//  Copyright © 2020 yunhao. All rights reserved.
//

import XCTest
@testable import Crystal

class WeakKeyDictionaryTests: XCTestCase {
    
    private var dictionary: WeakKeyDictionary<SimpleKey, SimpleObject>!

    override func setUp() {
        super.setUp()
        
        dictionary = WeakKeyDictionary<SimpleKey, SimpleObject>()
    }
    
    func testDictionarySubscriptSetter() {
        let total = 10
        var strongRetained: [SimpleKey] = []
        
        for _ in 0..<total {
            let key = SimpleKey()
            strongRetained.append(key)
            dictionary[key] = SimpleObject()
        }
        
        // All element is retained in the dictionary.
        XCTAssertEqual(dictionary.storage.count, total)
    }
    
    func testDictionarySubscriptGetter() {
        let total = 10
        var strongDict: [SimpleKey: SimpleObject] = [:]
        
        for _ in 0..<total {
            let key = SimpleKey()
            let object = SimpleObject()
            strongDict[key] = object
            dictionary[key] = object
        }
        
        // Get all elements successfully.
        for (key, object) in strongDict {
            XCTAssertEqual(dictionary[key], object)
        }
    }
    
    func testDictionaryWeakRetain() {
        let total = 10
        var strongRetained: [SimpleKey] = []
        
        for _ in 0..<total {
            let key = SimpleKey()
            strongRetained.append(key)
            dictionary[key] = SimpleObject()
        }
        
        // All element is retained in the dictionary.
        XCTAssertEqual(dictionary.storage.count, total)
        
        strongRetained.removeLast(total - 1)
        
        // Will not remove outdated elements automatically.
        XCTAssertEqual(dictionary.storage.count, total)
        
        // Remove outdated elements.
        dictionary.strip()
        XCTAssertEqual(dictionary.storage.count, 1)
    }
    
    func testDictionaryForEachObject() {
        let total = 10
        var strongRetained: [SimpleKey] = []
        
        for _ in 0..<total {
            let key = SimpleKey()
            strongRetained.append(key)
            dictionary[key] = SimpleObject()
        }
        
        // All element is retained in the dictionary.
        XCTAssertEqual(dictionary.storage.count, total)
        
        strongRetained.removeLast(total - 1)
        
        dictionary.forEachObject { _ in
            // Outdated elements should be removed automatically during iteration.
        }
        
        // Will not remove outdated elements automatically.
        XCTAssertEqual(dictionary.storage.count, 1)
    }
}

fileprivate class SimpleKey: NSObject {}
fileprivate class SimpleObject: NSObject {}
