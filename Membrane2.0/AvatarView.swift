//
//  AvatarView.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 28.08.2023.
//

import UIKit

class AvatarView: UIView {

    private(set) lazy var avatarImageView: UIImageView = {
        var doorImage = UIImageView()
        doorImage.contentMode = .scaleAspectFit
        doorImage.translatesAutoresizingMaskIntoConstraints = false
        return doorImage
    }()
    
    private(set) lazy var gradient: CAGradientLayer =  CAGradientLayer()
    
    private(set) lazy var maskLayer: CALayer =  {
        var maskLayer = CALayer()
        return maskLayer
    }()
    
    func apply(gradient: Gradient){
        self.gradient.colors = gradient.colors.map(\.cgColor)
        self.gradient.startPoint = CGPoint(x: 0.3, y: 0.0)
        self.gradient.endPoint = CGPoint(x: 0.7, y: 1.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(avatarImageView)
        NSLayoutConstraint.activate([avatarImageView.topAnchor.constraint(equalTo: self.topAnchor), avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor), avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor), avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])

        gradient.mask = maskLayer
        avatarImageView.layer.insertSublayer(gradient, at: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = avatarImageView.bounds.width
        let height = avatarImageView.bounds.height
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        maskLayer.frame = gradient.frame

    }
    
}
