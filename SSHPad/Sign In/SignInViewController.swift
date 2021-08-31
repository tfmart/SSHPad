//
//  SignInViewController.swift
//  SSHPad
//
//  Created by Tomas Martins on 25/08/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Components
    var stackView: UIStackView!
    var fieldsStackView: UIStackView!
    var usernameTextField: UITextField!
    var ipTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    
    // MARK: - Properties
    var viewModel: SignInViewModel = SignInViewModel()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.alertDelegate = self
        self.setupNavigation()
        self.setupComponents()
        self.setupUI()
    }
    
    // MARK: - UI Setup methods
    func setupNavigation() {
        self.title = "Sign in"
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    func setupComponents() {
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.delegate = viewModel
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.tag = TextFieldTag.username.rawValue
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        ipTextField = UITextField()
        ipTextField.placeholder = "IP Address"
        ipTextField.delegate = viewModel
        ipTextField.keyboardType = .decimalPad
        ipTextField.borderStyle = .roundedRect
        ipTextField.tag = TextFieldTag.ipAddress.rawValue
        ipTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.delegate = viewModel
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.tag = TextFieldTag.password.rawValue
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton = UIButton()
        loginButton.setTitle("Sign in via SSH", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.14, green: 0.31, blue: 0.67, alpha: 1.00)
        loginButton.tintColor = .white
        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        fieldsStackView = UIStackView()
        fieldsStackView.axis = .vertical
        fieldsStackView.alignment = .fill
        fieldsStackView.distribution = .equalSpacing
        fieldsStackView.isLayoutMarginsRelativeArrangement = true
        fieldsStackView.spacing = 24
        fieldsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUI() {
        fieldsStackView.addArrangedSubview(usernameTextField)
        fieldsStackView.addArrangedSubview(ipTextField)
        fieldsStackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(fieldsStackView)
        stackView.addArrangedSubview(loginButton)
        self.view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc func didTapSignIn() {
        self.view.endEditing(true)
        viewModel.signIn()
    }
    
    @objc func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignInViewController: SignInDelegate {
    func dismiss(didSucceed: Bool) {
        if let presentingViewController = (presentingViewController as? UINavigationController)?.viewControllers.first as? GalleryViewController {
            presentingViewController.didSucceed = didSucceed
        }
        self.dismiss(animated: true, completion: nil)
    }
}
