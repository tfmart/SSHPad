//
//  AlertDelegate.swift
//  SSHPad
//
//  Created by Tomas Martins on 29/08/21.
//

import Foundation

public protocol AlertDelegate: AnyObject {
    func displayAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?)
    func displayAlert(title: String?, message: String?, actionTitle: String?, handler: ((UIAlertAction) -> Void)?)
}

extension UIViewController: AlertDelegate {
    public func displayAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func displayAlert(title: String?, message: String?, actionTitle: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
