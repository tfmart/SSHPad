//
//  SPError.swift
//  SSHPad
//
//  Created by Tomas Martins on 03/09/21.
//

import Foundation

enum SPError: Error {
    case noCredentials
    case noConnection
    case notAuthorized
    
    var message: String? {
        switch self {
        case .noCredentials: return nil
        case .noConnection: return "Failed to connect to host"
        case .notAuthorized: return "Invalid credentials"
        }
    }
}
