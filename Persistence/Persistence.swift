//
//  Persistence.swift
//  Unity-iPhone
//
//  Created by Adam Shulman on 17/03/2025.
//

import Foundation

protocol PersistenceProtocol {
    func save<T>(_ value: T, forKey key: String)
    func load<T>(forKey key: String) -> T?
}

class PersistenceManager: PersistenceProtocol {
    
    let groupName = "group.com.shulman.TappWidget.TappWidgetExtension"
    
    func save<T>(_ value: T, forKey key: String) {
        UserDefaults.init(suiteName: groupName)?.set(value, forKey: key)
    }
    
    func load<T>(forKey key: String) -> T? {
        return UserDefaults.init(suiteName: groupName)?.object(forKey: key) as? T
    }
    
    func removeValue(forKey key: String) {
        UserDefaults.init(suiteName: groupName)?.removeObject(forKey: key)
    }
    
}
