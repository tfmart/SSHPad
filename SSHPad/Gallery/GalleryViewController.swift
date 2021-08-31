//
//  GalleryViewController.swift
//  SSHPad
//
//  Created by Tomas Martins on 25/08/21.
//

import UIKit
import NMSSH

class GalleryViewController: UIViewController {
    
    var didSucceed: Bool = false {
        didSet {
            view.subviews.forEach({ $0.removeFromSuperview() })
            if didSucceed {
                displaySuccessMessage()
            } else {
                displayConnectMessage()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scripts"
        self.view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        didSucceed = false
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
    
    func displaySuccessMessage() {
        let progressView = UIActivityIndicatorView(style: .gray)
        progressView.startAnimating()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func displaySignInSheet() {
        let signInViewController = UINavigationController(rootViewController: SignInViewController())
        signInViewController.modalPresentationStyle = .formSheet
        self.present(signInViewController, animated: true, completion: nil)
    }
}

