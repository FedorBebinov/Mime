//
//  DeviceCollectionViewCell.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 24.08.2023.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    private(set) lazy var nameLabel: UILabel = {
        var name  = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "test"
        return name
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: self.topAnchor), nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor), nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor), nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
