//
//  KeychainConstants.swift
//  SSHPad
//
//  Created by Tomas Martins on 30/08/21.
//

import Foundation

internal let service = "sshpad"

internal enum KeychainError: Error {
    case failedToCreateKeychain
    case operationFailed
}
