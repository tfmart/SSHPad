//
//  ViewController.swift
//  SSHPad
//
//  Created by Tomas Martins on 25/08/21.
//

import UIKit
import NMSSH

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scripts"
        self.view.backgroundColor = .white
        displayConnectMessage()
    }
    
    func displayConnectMessage() {
        let button = UIButton()
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(displaySignInSheet), for: .touchUpInside)
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func displaySignInSheet() {
        let signInViewController = UINavigationController(rootViewController: ConnectViewController())
        signInViewController.modalPresentationStyle = .formSheet
        self.present(signInViewController, animated: true, completion: nil)
    }
}

