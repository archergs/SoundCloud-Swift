//
//  File.swift
//  
//
//  Created by Ryan Forsyth on 2023-08-30.
//

import Foundation
import KeychainSwift

internal struct KeychainService<T: Codable>: ValuePersisting {
    internal typealias ValueType = T
    private let service = KeychainSwift()

    internal func get() -> T? {
        guard
            let valueData = service.getData(codingKey),
            // TODO: Throws
            let value = try? JSONDecoder().decode(T.self, from: valueData)
        else {
            return nil
        }
        return value
    }
    
    internal func save(_ value: T) {
        // TODO: Throws
        let valueData = try! JSONEncoder().encode(value)
        service.set(valueData, forKey: codingKey)
    }
    
    internal func delete() {
        service.delete(codingKey)
    }
}
