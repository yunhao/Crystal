//
//  WeakKeyMapTableTests.swift
//  CrystalTests
//
//  Created by yunhao on 2020/8/13.
//  Copyright © 2020 yunhao. All rights reserved.
//

import XCTest
@testable import Crystal

class WeakKeyMapTableTests: XCTestCase {
    
    private var mapTable: WeakKeyMapTable<SimpleKey, SimpleObject>!

    override func setUp() {
        super.setUp()
        
        mapTable = WeakKeyMapTable<SimpleKey, SimpleObject>()
    }
    
    func testMapTableSubscriptSetter() {
        let total = 10
        var strongRetained: [SimpleKey] = []
        
        for _ in 0..<total {
            let key = SimpleKey()
            strongRetained.append(key)
            mapTable[key] = SimpleObject()
        }
        
        // All element is retained in the map table.
        XCTAssertEqual(mapTable.storage.count, total)
    }
    
    func testMapTableSubscriptGetter() {
        let total = 10
        var strongDict: [SimpleKey: SimpleObject] = [:]
        
        for _ in 0..<total {
            let key = SimpleKey()
            let object = SimpleObject()
            strongDict[key] = object
            mapTable[key] = object
        }
        
        // Get all elements successfully.
        for (key, object) in strongDict {
            XCTAssertEqual(mapTable[key], object)
        }
    }
    
    func testMapTableWeakRetain() {
        let total = 10
        var strongRetained: [SimpleKey] = []
        
        for _ in 0..<total {
            let key = SimpleKey()
            strongRetained.append(key)
            mapTable[key] = SimpleObject()
        }
        
        // All element is retained in the map table.
        XCTAssertEqual(mapTable.storage.count, total)
        
        strongRetained.removeLast(total - 1)
        
        // Will remove outdated elements automatically.
        XCTAssertEqual(mapTable.storage.count, 1)
    }
}

fileprivate class SimpleKey: NSObject {}
fileprivate class SimpleObject: NSObject {}
