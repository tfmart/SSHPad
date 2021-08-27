//
//  SignInViewModel.swift
//  SSHPad
//
//  Created by Tomas Martins on 26/08/21.
//

import Foundation
import NMSSH
import SwiftKeychainWrapper

public class SignInViewModel: NSObject {
    var username: String?
    var ipAddress: String?
    var password: String?
    
    private func storeCredetials() {
        guard let username =  username,
              let ipAddress = ipAddress,
              let password = password else {
            // Could log in but information was nil
            return
        }
        
        KeychainWrapper.standard.set(username, forKey: "username")
        KeychainWrapper.standard.set(ipAddress, forKey: "ipAddress")
        KeychainWrapper.standard.set(password, forKey: "password")
    }
    
    public func signIn() {
        guard let username =  username,
              let ipAddress = ipAddress,
              let password = password else {
            // One of the fields are empty
            return
        }
        
        let session = NMSSHSession(host: ipAddress, andUsername: username)
        session.connect()
        guard session.isConnected else {
            //Failed to connect to host
            return
        }
        
        session.authenticate(byPassword: password)
        guard session.isAuthorized else {
            //Password is invalid
            return
        }
        
        self.storeCredetials()
        
        var error: NSError?
        let response: String = session.channel.execute("osascript Documents/SSHPad/terminal.scpt", error: &error)
        print(response)
        session.disconnect()
    }
}

extension SignInViewModel: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let tag = TextFieldTag(rawValue: textField.tag) else { return }
        switch tag {
        case .username: username = textField.text
        case .ipAddress: ipAddress = textField.text
        case .password: password = textField.text
        }
    }
}
