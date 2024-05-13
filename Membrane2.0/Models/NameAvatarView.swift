//
//  NameAvatarView.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 29.04.2024.
//

import UIKit

class NameAvatarView: AvatarView {
    
    private(set) lazy var name = MainFactory.topLabel(text: "")
    private(set) lazy var starImageView = UIImageView(image: .init(resource: .star))
    private(set) lazy var orbit1ImageView = UIImageView(image: .init(resource: .orbit1))
    private(set) lazy var orbit2ImageView = UIImageView(image: .init(resource: .orbit2))

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
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        orbit1ImageView.translatesAutoresizingMaskIntoConstraints = false
        orbit2ImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameBackground)
        self.addSubview(name)
        nameBackground.addSubview(starImageView)
        nameBackground.addSubview(orbit1ImageView)
        nameBackground.addSubview(orbit2ImageView)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.addGestureRecognizer(singleTap)
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            nameBackground.leadingAnchor.constraint(equalTo: name.leadingAnchor, constant: -13),
            nameBackground.trailingAnchor.constraint(equalTo: name.trailingAnchor, constant: 13),
            nameBackground.topAnchor.constraint(equalTo: name.topAnchor, constant: -10.5),
            nameBackground.bottomAnchor.constraint(equalTo: name.bottomAnchor, constant: 11.5),

            starImageView.trailingAnchor.constraint(equalTo: nameBackground.trailingAnchor),
            starImageView.bottomAnchor.constraint(equalTo: nameBackground.bottomAnchor, constant: 2),

            orbit2ImageView.centerYAnchor.constraint(equalTo: nameBackground.centerYAnchor, constant: -4),
            orbit2ImageView.leadingAnchor.constraint(equalTo: nameBackground.leadingAnchor, constant: -10),

            orbit1ImageView.centerYAnchor.constraint(equalTo: nameBackground.centerYAnchor),
            orbit1ImageView.leadingAnchor.constraint(equalTo: nameBackground.leadingAnchor, constant: -20)
        ])

        let accessoryEnabled = UserDefaults.standard.accessoryEnabled
        starImageView.isHidden = !accessoryEnabled
        orbit1ImageView.isHidden = !accessoryEnabled
        orbit2ImageView.isHidden = !accessoryEnabled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleTap() {
        tapHandler?()
    }
}
