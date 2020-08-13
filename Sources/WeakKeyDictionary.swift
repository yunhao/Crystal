//
//  WeakKeyDictionary.swift
//  Crystal
//
//  Created by yunhao on 2020/8/11.
//  Copyright © 2020 yunhao. All rights reserved.
//

import Foundation

/// A wrapper box used to wrap an object with weak reference.
class WeakBox: Hashable {
    /// The weak object. When the object is deallocated, this value will set to nil. Use this property to determine if the object is deallocated.
    weak var object: AnyObject?
    
    /// Use a `NSValue` to wrap the weak object without retained reference. This property is designed to implement `Hashable`.
    /// Dont't try to access the weak object from this property, or crash will occur if the object is deallocated.
    var hashWrapper: NSValue
    
    /// Wrap the value in a wrapper that retain a weak referencne to the value.
    /// - Parameter object: A class type value.
    init(nonretained object: AnyObject) {
        self.object = object
        hashWrapper = NSValue(nonretainedObject: object)
    }
    
    func hash(into hasher: inout Hasher) {
        hashWrapper.hash(into: &hasher)
    }
    
    static func == (lhs: WeakBox, rhs: WeakBox) -> Bool {
        return lhs.hashWrapper == rhs.hashWrapper
    }
}

class WeakKeyBox: WeakBox {}

/// A  weak to strong dictionary used to store elements with weak key and strong value.
///
/// To implement the functionality, `WeakKeyDictionary` uses `WeakKeyBox` key wrapper to wrap your actual weak key internally.
/// It is important to know that when the actual weak key of an element is deallocated, the dictionary won't remove the element automatically.
///
/// You can call `strip()` to remove all outdated elements. When iterating the dictionary, check `key.object` to determine whether
/// the actual weak key is deallocated or not.
class WeakKeyDictionary<WeakKey, Value> where WeakKey: AnyObject {
    /// A wrapper of the weak key. This is the real key type used in internal storage.
    typealias Key = WeakKeyBox
    
    /// The interal storage.
    typealias InternalStorage = Dictionary<Key, Value>
    typealias Index = InternalStorage.Index
    typealias Element = (key: WeakKeyBox, value: Value)
    
    /// The internal storage.
    var storage: InternalStorage = [:]
    
    /// Removes all elements from the dictionary.
    func removeAll() {
        storage.removeAll()
    }
    
    /// Calls the given closure on each elements. When you call this function, outdated elements will be removed and only elements with
    /// un-deallocated weak key will participate.
    func forEachObject(_ closure: (Value) -> Void) {
        for (key, value) in storage {
            if let _ = key.object {
                closure(value)
            } else {
                storage.removeValue(forKey: key)
            }
        }
    }
    
    /// Remove all elements whose weak key is deallocated.
    func strip() {
        for (key, _) in storage {
            if key.object == nil { storage.removeValue(forKey: key) }
        }
    }
}

extension WeakKeyDictionary: Collection {

    var startIndex: Index { storage.startIndex }
    
    var endIndex: Index { storage.endIndex }
    
    func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
        return storage.index(after: i)
    }
    
    subscript(position: InternalStorage.Index) -> InternalStorage.Element {
        return storage[position]
    }
    
    subscript(key: Key) -> Value? {
        get { storage[key] }
        set { storage[key] = newValue }
    }
    
    /// Accesses the value associated with the given weak key for reading and writing.
    subscript(weakKey: WeakKey) -> Value? {
        get { storage[Key(nonretained: weakKey)] }
        set { storage[Key(nonretained: weakKey)] = newValue }
    }
}
