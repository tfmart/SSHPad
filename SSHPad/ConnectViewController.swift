//
//  ConnectViewController.swift
//  SSHPad
//
//  Created by Tomas Martins on 25/08/21.
//

import UIKit

class ConnectViewController: UIViewController {
    
    var stackView: UIStackView!
    var fieldsStackView: UIStackView!
    var usernameTextField: UITextField!
    var ipTextField: UITextField!
    var passwordTextField: UITextField!
    
    var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.setupUI()
    }
    
    @objc func login() {
        let session = NMSSHSession(host: ipTextField.text!, andUsername: usernameTextField.text!)
        session.connect()
        if session.isConnected {
            session.authenticate(byPassword: passwordTextField.text!)
            
            if session.isAuthorized {
                print("Authorized!")
            }
        }
        
        var error: NSError?
        let response: String = session.channel.execute("osascript Documents/SSHPad/terminal.scpt", error: &error)
        print(response)
        session.disconnect()
    }
    
    func setupComponents() {
        self.title = "Sign in"
        self.view.backgroundColor = .white
        
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        ipTextField = UITextField()
        ipTextField.placeholder = "IP Address"
        ipTextField.keyboardType = .decimalPad
        ipTextField.borderStyle = .roundedRect
        ipTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton = UIButton()
        loginButton.setTitle("Sign in with SSH", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.14, green: 0.31, blue: 0.67, alpha: 1.00)
        loginButton.tintColor = .white
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUI() {
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(ipTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        self.view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}
