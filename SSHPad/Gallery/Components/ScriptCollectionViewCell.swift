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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupComponents()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupComponents() {
        self.label = UILabel()
        self.label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUI() {
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
