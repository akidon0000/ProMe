//
//  Dictionary.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/07.
//

import Foundation

// 順序付き辞書の提供
struct OrderedDictionary<Key: Hashable, Value> {
    private var keys: [Key] = []
    private var values: [Key: Value] = [:]
    
    var count: Int {
        return keys.count
    }
    
    subscript(key: Key) -> Value? {
        get {
            return values[key]
        }
        set {
            if let value = newValue {
                if !keys.contains(key) {
                    keys.append(key)
                }
                values[key] = value
            } else {
                if let index = keys.firstIndex(of: key) {
                    keys.remove(at: index)
                }
                values.removeValue(forKey: key)
            }
        }
    }
    
    func value(at index: Int) -> Value? {
        guard index >= 0 && index < keys.count else { return nil }
        let key = keys[index]
        return values[key]
    }
}
