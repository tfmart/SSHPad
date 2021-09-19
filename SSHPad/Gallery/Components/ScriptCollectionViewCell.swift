//
//  ScriptCollectionViewCell.swift
//  SSHPad
//
//  Created by Tomas Martins on 03/09/21.
//

import UIKit

class ScriptCollectionViewCell: UICollectionViewCell {
    private var nameLabel: UILabel!
    private var imageView: UIImageView!
    
    var title: String? {
        didSet {
            nameLabel.text = title
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            if oldValue == nil && image != nil {
                setupUI()
            }
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
        self.nameLabel = UILabel()
        self.imageView = UIImageView()
        self.layer.cornerRadius = 8.0
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        if image != nil {
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        } else {
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        }
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
