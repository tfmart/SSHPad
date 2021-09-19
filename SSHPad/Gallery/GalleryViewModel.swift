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
    weak var delegate: GalleryDelegate?
    weak var alertDelegate: AlertDelegate?
    
    private var scripts: [Script] = []
    
    public func fetchScripts() {
        var error: NSError?
        guard let session = session else { return }
        let response: String = session.channel.execute("ls \(scriptsDirectory)", error: &error)
        guard error == nil else {
            //handle error
            return
        }
        let files = response.components(separatedBy: "\n").filter({ !$0.isEmpty })
        files.forEach({ scripts.append(Script(name: $0, fileName: $0, image: nil))})
        print(scripts)
    }
    
    public func script(for row: Int) -> Script? {
        guard row < amount else { return nil }
        return scripts[row]
    }
    
    public func didSelect(at row: Int) {
        guard let session = session else { return }
        var runScriptError: NSError?
        session.channel.execute("osascript \(scriptsDirectory)/\(scripts[row].fileName)", error: &runScriptError)
    }
    
    public func signOut() {
        try? KeychainWrapper.wipeAllData()
    }
}

// MARK: - Public properties
extension GalleryViewModel {
    public func signIn() throws {
        guard let username = self.username,
              let credential = self.credential,
              let host = self.host else {
            throw SPError.noCredentials
        }
        session = NMSSHSession(host: host, andUsername: username)
        session?.connect()
        guard let isConnected = session?.isConnected, isConnected else {
            alertDelegate?.displayAlert(title: "Could not connect to host", message: "Make sure both this device and the host are connected to your network", action: nil)
            throw SPError.noConnection
        }
        session?.authenticate(byPassword: credential)
        guard let isAuthorized = session?.isAuthorized, isAuthorized else {
            alertDelegate?.displayAlert(title: "Invalid credentials", message: "Could not connect with the current credentials. Please sign-in again", action: nil)
            throw SPError.notAuthorized
        }
    }
    
    public var amount: Int {
        return scripts.count
    }
}

// MARK: - Private properties
extension GalleryViewModel {
    private var username: String? {
        return try? KeychainWrapper.read(from: "username")
    }
    
    private var host: String? {
        return try? KeychainWrapper.read(from: "host")
    }
    
    private var credential: String? {
        return try? KeychainWrapper.read(from: "password")
    }
}

// MARK: - Pointer Interaction
@available(iOS 13.4, *)
extension GalleryViewModel: UIPointerInteractionDelegate {
    func customPointerInteraction(on view: UIView, pointerInteractionDelegate:
                                  UIPointerInteractionDelegate){
        let pointerInteraction = UIPointerInteraction(delegate:
                                                        pointerInteractionDelegate)
        view.addInteraction(pointerInteraction)
    }
    
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region:
                            UIPointerRegion) -> UIPointerStyle? {
        var pointerStyle: UIPointerStyle?
        
        if let interactionView = interaction.view {
            let targetedPreview = UITargetedPreview(view: interactionView)
            pointerStyle = UIPointerStyle(effect:
                                            UIPointerEffect.highlight(targetedPreview))
        }
        return pointerStyle
    }
}
