//
//  UserDefaults.swift
//  SwyzzySwiftUI
//
//  Created by Василий Усов on 09.02.2022.
//

import Foundation

@propertyWrapper
struct UDPersisted<T: Codable> {
    
    let key: String
    let storage: UserDefaults = .standard
    
    var wrappedValue: T? {
        get {
            guard let rawData = storage.data(forKey: key),
                  let resultInstance = try? PropertyListDecoder().decode(PhoneNumber.self, from: rawData) as? T
            else { return nil }
            return resultInstance
        }
        set {
            storage.set(try? PropertyListEncoder().encode(newValue), forKey: key)
        }
    }
}
