//
//  DAO.swift
//  
//
//  Created by Ryan Forsyth on 2023-08-30.
//

/// Describes a data access object used for persisting an item of generic codable type `DataType`
 /// - Parameters:
///   - codingKey: key used to encode + decode persisted object
public protocol DAO: AnyObject {
    associatedtype DataType: Codable
    
    var codingKey: String { get }
    
    func get() throws -> DataType
    func save(_ value: DataType) throws
    func delete() throws
}
