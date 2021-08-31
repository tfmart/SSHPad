//
//  SignInViewModel.swift
//  SSHPad
//
//  Created by Tomas Martins on 26/08/21.
//

import Foundation
import NMSSH


public class SignInViewModel: NSObject {
    var username: String?
    var ipAddress: String?
    var password: String?
    
    private var session: NMSSHSession!
    weak var alertDelegate: AlertDelegate?
    
    private func storeCredetials() {
        guard let username =  username,
              let ipAddress = ipAddress,
              let password = password else {
            // Could log in but information was nil
            return
        }
        
        let values: [String: String] = [
            "username": username,
            "ipAddress": ipAddress,
            "password": password
        ]
        
        do {
            try KeychainWrapper.set(values: values)
        } catch {
            //handle error
        }
    }
    
    public func signIn() {
        guard let username =  username,
              let ipAddress = ipAddress,
              let password = password else {
            // One of the fields are empty
            return
        }
        
        session = NMSSHSession(host: ipAddress, andUsername: username)
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
        let response: String = session.channel.execute("if [ -d ~/Documents/SSHPad\\ Scripts ]\nthen\necho \"dir present\"\nelse\necho \"dir not present\"\nfi", error: &error)
        switch response.replacingOccurrences(of: "\n", with: "") {
        case "dir present":
            alertDelegate?.displayAlert(title: "Success", message: "Found SSHPad Scripts directory")
            session.disconnect()
        case "dir not present":
            offerToCreateDirectory()
        default:
            break
        }
    }
    
    private func offerToCreateDirectory() {
        alertDelegate?.displayAlert(title: "Could not find scripts", message: "Could not locate the SSHPad Scripts directory on the host device. Would you like to create the directory?", actionTitle: "Create", handler: createDirectory(alert:))
    }
    
    private func createDirectory(alert: UIAlertAction) {
        var createDirError: NSError?
        _ = session.channel.execute("mkdir ~/Documents/SSHPad\\ Scripts", error: &createDirError)
        guard createDirError == nil else {
            alertDelegate?.displayAlert(title: "Something went wrong", message: "Could not create the scripts directory")
            session.disconnect()
            return
        }
        alertDelegate?.displayAlert(title: "Directory created successfully", message: "Now add your scripts in the added directory, which is located at:\n\n~/Documents/SSHPad Scripts")
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
