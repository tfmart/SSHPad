//
//  SignInDelegate.swift
//  SSHPad
//
//  Created by Tomas Martins on 30/08/21.
//

import Foundation

public protocol SignInDelegate: AnyObject {
    func showLoading()
    func hideLoading()
    func dismiss(didSucceed: Bool)
}
