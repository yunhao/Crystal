//
//  WeakKeyMapTable.swift
//  Crystal
//
//  Created by yunhao on 2020/8/11.
//  Copyright © 2020 yunhao. All rights reserved.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var disposeBag: UInt8 = 0
}

/// A dispose bag used to remove elements from `WeakKeyMapTable` when the weak key object is deallocated.
fileprivate class DisposeBag {
    var closure: () -> Void
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    deinit {
        closure()
    }
}

/// A wrapper box used to wrap an object with weak reference.
class WeakBox: Hashable {
    /// The weak object. When the object is deallocated, this value will set to nil. Use this property to determine if the object is deallocated.
    weak var object: AnyObject?
    
    /// Use a `NSValue` to wrap the weak object without retained reference. This property is designed to implement `Hashable`.
    /// Dont't try to access the weak object from this property, otherwise crash will occur if the object is deallocated.
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
    
    /// Set a closure that will be called when the weak object is deallocated.
    func onDispose(_ closure: @escaping () -> Void) {
        objc_setAssociatedObject(
            object!,
            &AssociatedKeys.disposeBag,
            DisposeBag(closure),
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}

class WeakKeyBox: WeakBox {}

/// A  weak to strong map table used to store elements with weak key and strong value.
///
/// To implement the functionality, `WeakKeyMapTable` uses `WeakKeyBox` to wrap your weak key object internally.
/// When the weak key object of an element is deallocated, the map table will remove the element automatically.
///
/// You can access the weak key object inside the `WeakKeyBox` wrapper via `keyBox.object`.
class WeakKeyMapTable<WeakKey, Value> where WeakKey: AnyObject {
    /// A wrapper of the weak key. This is the real key type used in internal storage.
    typealias Key = WeakKeyBox
    
    /// The interal storage type.
    typealias InternalStorage = Dictionary<Key, Value>
    typealias Index = InternalStorage.Index
    typealias Element = (key: WeakKeyBox, value: Value)
    
    /// The internal storage.
    var storage: InternalStorage = [:]
    
    /// Removes all elements from the map table.
    func removeAll() {
        storage.removeAll()
    }
}

extension WeakKeyMapTable: Collection {

    var startIndex: Index { storage.startIndex }
    
    var endIndex: Index { storage.endIndex }
    
    func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
        return storage.index(after: i)
    }
    
    subscript(position: InternalStorage.Index) -> InternalStorage.Element {
        return storage[position]
    }
    
    /// Accesses the value associated with the given weak key object for reading and writing.
    subscript(weakKey: WeakKey) -> Value? {
        get { storage[Key(nonretained: weakKey)] }
        set {
            let key = Key(nonretained: weakKey)
            // When the weak key object is deallocated, remove the associated element from map table.
            key.onDispose { [unowned self] in
                self.storage.removeValue(forKey: key)
            }
            
            storage[key] = newValue
        }
    }
}
