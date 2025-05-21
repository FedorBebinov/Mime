//
//  AvatarView.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 28.08.2023.
//

import UIKit

//class AvatarView: UIView
class AvatarView: UICollectionViewCell {
    lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let gradientLayer = CAGradientLayer()
    private var maskImage: UIImage?
    private var gradient: Gradient?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        avatarImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = avatarImageView.bounds
        updateGradientAndMask()
    }
    
    func apply(gradient: Gradient) {
        self.gradient = gradient
        updateGradientAndMask()
    }
    func applyMask(image: UIImage?) {
        self.maskImage = image
        updateGradientAndMask()
    }
    private func updateGradientAndMask() {
        // Обновление градиента
        if let gradient = self.gradient {
            gradientLayer.colors = gradient.colors.map(\.cgColor)
            gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.7, y: 1.0)
        }
        // Обновление маски
        guard let image = maskImage, let cgImage = image.cgImage else {
            gradientLayer.mask = nil
            return
        }
        let bounds = gradientLayer.bounds
        let maskRect = aspectFitFrame(for: CGSize(width: cgImage.width, height: cgImage.height), in: bounds)
        let maskLayer = CALayer()
        maskLayer.contents = cgImage
        maskLayer.frame = maskRect
        gradientLayer.mask = maskLayer
    }
    private func aspectFitFrame(for imageSize: CGSize, in boundingRect: CGRect) -> CGRect {
        guard imageSize.width > 0 && imageSize.height > 0 else { return boundingRect }
        let imageAspect = imageSize.width / imageSize.height
        let viewAspect = boundingRect.width / boundingRect.height
        var fitSize = CGSize()
        if imageAspect > viewAspect {
            fitSize.width = boundingRect.width
            fitSize.height = boundingRect.width / imageAspect
        } else {
            fitSize.height = boundingRect.height
            fitSize.width = boundingRect.height * imageAspect
        }
        let origin = CGPoint(
            x: boundingRect.midX - fitSize.width/2,
            y: boundingRect.midY - fitSize.height/2
        )
        return CGRect(origin: origin, size: fitSize)
    }
}
