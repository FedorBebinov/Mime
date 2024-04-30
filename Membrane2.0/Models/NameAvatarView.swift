//
//  NameAvatarView.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 29.04.2024.
//

import UIKit

class NameAvatarView: AvatarView {
    
    private(set) lazy var name = MainFactory.topLabel(text: "")
    
    var tapHandler: (() -> Void)?
    
    private lazy var nameBackground: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 18
        background.backgroundColor = .buttonColor.withAlphaComponent(0.3)
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameBackground)
        self.addSubview(name)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.addGestureRecognizer(singleTap)
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
            nameBackground.leadingAnchor.constraint(equalTo: name.leadingAnchor, constant: -13),
            nameBackground.trailingAnchor.constraint(equalTo: name.trailingAnchor, constant: 13),
            nameBackground.topAnchor.constraint(equalTo: name.topAnchor, constant: -10.5),
            nameBackground.bottomAnchor.constraint(equalTo: name.bottomAnchor, constant: 11.5)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleTap() {
        tapHandler?()
    }
}
