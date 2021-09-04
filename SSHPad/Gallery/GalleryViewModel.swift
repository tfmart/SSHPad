//
//  GalleryViewModel.swift
//  SSHPad
//
//  Created by Tomas Martins on 30/08/21.
//

import Foundation
import NMSSH

let scriptsDirectory = "~/Documents/SSHPad\\ Scripts"

class GalleryViewModel: NSObject {
    var session: NMSSHSession?
    public var scripts: [String] = []
    
    public var connectionStatus: ConnectionStatus? {
        didSet {
            // setup view according to status
        }
    }
    
    public func fetchScripts() {
        var error: NSError?
        guard let session = session else { return }
        let response: String = session.channel.execute("ls \(scriptsDirectory)", error: &error)
        guard error == nil else {
            //handle error
            return
        }
        scripts = response.components(separatedBy: "\n").filter({ !$0.isEmpty })
        print(scripts)
    }
    
    public func signOut() {
        try? KeychainWrapper.wipeAllData()
    }
}

// MARK: - Public properties
extension GalleryViewModel {
    public var isSignedIn: Bool {
        guard let username = self.username,
              let credential = self.credential,
              let ipAddres = self.ipAddres else {
            return false
        }
        session = NMSSHSession(host: ipAddres, andUsername: username)
        session?.connect()
        guard let isConnected = session?.isConnected, isConnected else {
            return false
        }
        session?.authenticate(byPassword: credential)
        return session?.isAuthorized ?? false
    }
}

// MARK: - Private properties
extension GalleryViewModel {
    private var username: String? {
        return try? KeychainWrapper.read(from: "username")
    }
    
    private var ipAddres: String? {
        return try? KeychainWrapper.read(from: "ipAddress")
    }
    
    private var credential: String? {
        return try? KeychainWrapper.read(from: "password")
    }
}
