//
//  KeychainOperations.swift
//  SSHPad
//
//  Created by Tomas Martins on 30/08/21.
//

import Foundation

internal class KeychainOperations {
    internal static func exists(key: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: false
            ] as NSDictionary, nil)
        
        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            throw KeychainError.failedToCreateKeychain
        }
    }
    
    internal static func save(key: String, value: String) throws {
        let status = SecItemAdd([
            kSecClass:kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value.data(using: .utf8)!
        ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.operationFailed }
    }
    
    internal static func update(key: String, value: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service
        ] as NSDictionary, [
            kSecValueData: value.data(using: .utf8)!
        ] as NSDictionary)
        guard status == errSecSuccess else { throw KeychainError.operationFailed }
    }
    
    internal static func delete(from key: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service
        ] as NSDictionary)
        guard status == errSecSuccess else { throw KeychainError.operationFailed }
    }
    
    internal static func retrieve(from key: String) throws -> String? {
        var result: AnyObject?
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: true
        ] as NSDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.operationFailed
        }
    }
}
