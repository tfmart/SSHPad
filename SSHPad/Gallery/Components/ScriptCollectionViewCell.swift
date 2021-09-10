//
//  ScriptCollectionViewCell.swift
//  SSHPad
//
//  Created by Tomas Martins on 03/09/21.
//

import UIKit

class ScriptCollectionViewCell: UICollectionViewCell {
    private var label: UILabel!
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupComponents()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        self.label = UILabel()
        self.layer.cornerRadius = 8.0
        self.label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func toggleAnimation() {
        if isHighlighted {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                            self.alpha = 0.8
                self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.alpha = 1.0
                self.transform = CGAffineTransform.identity
            }
        }
        
    }
}
