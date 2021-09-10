//
//  Color+Theme.swift
//  SSHPad
//
//  Created by Tomas Martins on 09/09/21.
//

import UIKit

extension UIColor {
    static var primaryBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}
