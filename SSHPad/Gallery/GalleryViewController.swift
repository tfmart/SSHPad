//
//  GalleryViewController.swift
//  SSHPad
//
//  Created by Tomas Martins on 25/08/21.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var scriptsCollectionView: UICollectionView!
    var viewModel = GalleryViewModel()
    
    var didSucceed: Bool = false {
        didSet {
            view.subviews.forEach({ $0.removeFromSuperview() })
            checkSession()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scripts"
        self.view.backgroundColor = .primaryBackground
        checkSession()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    func checkSession() {
        do {
            try viewModel.signIn()
            viewModel.fetchScripts()
            setupComponents()
            setupUI()
        } catch {
            guard let spError = error as? SPError else {
                return
            }
            switch spError {
            case .noCredentials: displayConnectMessage()
            case .noConnection, .notAuthorized: displayMessage(with: spError)
            }
        }
    }
    
    func displayConnectMessage() {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Get started", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(displaySignInSheet), for: .touchUpInside)
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func displayMessage(with error: SPError) {
        let label = UILabel()
        label.text = error.message
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func displaySignInSheet() {
        let signInViewController = UINavigationController(rootViewController: SignInViewController())
        signInViewController.modalPresentationStyle = .formSheet
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    private func setupComponents() {
        self.scriptsCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: GalleryCollectionViewLayout(sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        self.scriptsCollectionView.dataSource = self
        self.scriptsCollectionView.delegate = self
        self.scriptsCollectionView.register(ScriptCollectionViewCell.self, forCellWithReuseIdentifier: "script")
        if #available(iOS 13.0, *) { } else {
            scriptsCollectionView.addGestureRecognizer(longPress)
        }
        if #available(iOS 11.0, *) {
            scriptsCollectionView?.contentInsetAdjustmentBehavior = .always
        }
        scriptsCollectionView.backgroundColor = .primaryBackground
        scriptsCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        scriptsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUI() {
        self.view.addSubview(scriptsCollectionView)
        scriptsCollectionView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        scriptsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scriptsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scriptsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: - Collection View methods
extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.amount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "script", for: indexPath) as! ScriptCollectionViewCell
        cell.title = viewModel.script(for: indexPath.row)?.fileName
        cell.backgroundColor = UIColor.orange
        if #available(iOS 13.4, *) {
            cell.image = UIImage(systemName: "star.fill")
            viewModel.customPointerInteraction(on: cell, pointerInteractionDelegate: viewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.row)
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { actions in
            return UIMenu(title: "Edit script", children: self.viewModel.menuActions)
        }
    }
}

//MARK: - Long gesture for iOS <13
extension GalleryViewController: UIGestureRecognizerDelegate {
    var longPress: UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        return gesture
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
                let touchPoint = gestureRecognizer.location(in: scriptsCollectionView)
                if let index = scriptsCollectionView.indexPathForItem(at: touchPoint),
                   let alertController = viewModel.editAlert(for: index.row) {
                    let popOverController = alertController.popoverPresentationController
                    popOverController?.sourceView = scriptsCollectionView.cellForItem(at: index)
                    popOverController?.sourceRect = scriptsCollectionView.cellForItem(at: index)!.bounds
                    self.present(alertController, animated: true, completion: nil)
                }
            }
    }
}
