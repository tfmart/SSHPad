//
//  KeychainWrapper.swift
//  SSHPad
//
//  Created by Tomas Martins on 30/08/21.
//

import Foundation

public class KeychainWrapper {
    public static func set(values: [String: String]) throws {
        do {
            try values.forEach {
                try set(key: $0.key, value: $0.value)
            }
        } catch {
            throw KeychainError.operationFailed
        }
    }
    
    public static func read(from key: String) throws -> String? {
        if try KeychainOperations.exists(key: key) {
            return try KeychainOperations.retrieve(from: key)
        } else {
            throw KeychainError.operationFailed
        }
    }
    
    public static func set(key: String, value: String) throws {
        if try KeychainOperations.exists(key: key) {
            try KeychainOperations.update(key: key, value: value)
        } else {
            try KeychainOperations.save(key: key, value: value)
        }
    }
    
    public static func delete(key: String) throws {
        if try KeychainOperations.exists(key: key) {
            return try KeychainOperations.delete(from: key)
        } else {
            throw KeychainError.operationFailed
        }
    }
    
    public static func wipeAllData() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword
        ] as NSDictionary)
        guard status == errSecSuccess else { throw KeychainError.operationFailed }
    }
}
