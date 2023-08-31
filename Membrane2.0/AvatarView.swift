//
//  AvatarView.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 28.08.2023.
//

import UIKit

class AvatarView: UIView {

    private(set) lazy var doorImageView: UIImageView = {
        var doorImage = UIImageView()
        doorImage.translatesAutoresizingMaskIntoConstraints = false
        return doorImage
    }()
    
    private(set) lazy var gradient: CAGradientLayer =  CAGradientLayer()
    
    private(set) lazy var maskLayer: CALayer =  {
        var maskLayer = CALayer()
        return maskLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(doorImageView)
        NSLayoutConstraint.activate([doorImageView.topAnchor.constraint(equalTo: self.topAnchor), doorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor), doorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor), doorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])

        gradient.mask = maskLayer
        doorImageView.layer.insertSublayer(gradient, at: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = doorImageView.bounds.width
        let height = doorImageView.bounds.height
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        maskLayer.frame = gradient.frame

    }
    
}
