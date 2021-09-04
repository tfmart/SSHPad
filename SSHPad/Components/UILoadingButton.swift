//
//  UILoadingButton.swift
//  SSHPad
//
//  Created by Tomas Martins on 30/08/21.
//

import UIKit

public class UILoadingButton: UIButton {

    private var activityIndicator: UIActivityIndicatorView!
    
    private var title: String?
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        guard let title = title, !title.isEmpty else { return }
        self.title = title
    }

    public func startLoading() {
        if activityIndicator == nil {
            self.setupIndicator()
        }
        self.isEnabled = false
        self.setTitle("", for: .disabled)
        activityIndicator.startAnimating()
    }
    
    public func stopLoading() {
        self.isEnabled = true
        activityIndicator.stopAnimating()
        self.setTitle(title, for: .normal)
    }
    
    private func setupIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.center = self.center
    }
}
