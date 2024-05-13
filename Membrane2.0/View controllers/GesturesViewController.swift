//
//  GesturesViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 26.02.2024.
//

import UIKit

class GesturesViewController: UIViewController {
    
    private let gesturesTextLabel = MainFactory.gestureTextLabel(text: NSLocalizedString("gestureText", comment: ""))
    
    private lazy var fingersTextLabel = MainFactory.topLabel(text: NSLocalizedString("fingersText", comment: ""))
    
    private let touchImageView: UIImageView = {
        let image = UIImage(resource: .touch).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let zoomImageView: UIImageView = {
        let image = UIImage(resource: .zoom).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let longPressImageView: UIImageView = {
        let image = UIImage(resource: .longPress).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let motionImageView: UIImageView = {
        let image = UIImage(resource: .motion).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let onefingerImageView: UIImageView = {
        let image = UIImage(resource: .oneFinger).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let twofingersImageView: UIImageView = {
        let image = UIImage(resource: .twoFingers).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let threefingersImageView: UIImageView = {
        let image = UIImage(resource: .threeFingers).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let fourfingersImageView: UIImageView = {
        let image = UIImage(resource: .fourFingers).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var fingersButton = MainFactory.separatedBigButton(text: NSLocalizedString("fingersTypes", comment: ""))
    
    private lazy var fingersTopSeparator = MainFactory.separator()
    
    private lazy var fingersBottomeparator = MainFactory.separator()
    
    private lazy var gesturesButton = MainFactory.separatedBigButton(text: NSLocalizedString("gesturesTypes", comment: ""))
    
    private lazy var gesturesTopSeparator = MainFactory.separator()
    
    private lazy var gesturesBottomSeparator = MainFactory.separator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .textColor
        
        view.addSubview(gesturesTextLabel)
        view.addSubview(touchImageView)
        view.addSubview(zoomImageView)
        view.addSubview(longPressImageView)
        view.addSubview(motionImageView)
        view.addSubview(fingersButton)
        view.addSubview(gesturesButton)
        view.addSubview(fingersTopSeparator)
        view.addSubview(fingersBottomeparator)
        view.addSubview(gesturesTopSeparator)
        view.addSubview(gesturesBottomSeparator)
        view.addSubview(fingersTextLabel)
        view.addSubview(onefingerImageView)
        view.addSubview(twofingersImageView)
        view.addSubview(threefingersImageView)
        view.addSubview(fourfingersImageView)
        
        fingersTextLabel.numberOfLines = 0
        gesturesButton.isEnabled = false
        fingersTextLabel.isHidden = true
        onefingerImageView.isHidden = true
        twofingersImageView.isHidden = true
        threefingersImageView.isHidden = true
        fourfingersImageView.isHidden = true
        
        fingersButton.addTarget(self, action: #selector(fingersButtonTapped), for: .touchUpInside)
        gesturesButton.addTarget(self, action: #selector(gesturesButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            gesturesTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 43),
            gesturesTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            gesturesTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            fingersTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 43),
            fingersTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            fingersTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            touchImageView.topAnchor.constraint(equalTo: gesturesTextLabel.bottomAnchor, constant: 40),
            touchImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            touchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 180/844),

            onefingerImageView.topAnchor.constraint(equalTo: fingersTextLabel.bottomAnchor, constant: 65),
            onefingerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            onefingerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 230/844),

            motionImageView.topAnchor.constraint(equalTo: gesturesTextLabel.bottomAnchor, constant: 40),
            motionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            motionImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 180/844),

            twofingersImageView.topAnchor.constraint(equalTo: fingersTextLabel.bottomAnchor, constant: 65),
            twofingersImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            twofingersImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 230/844),

            longPressImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            longPressImageView.topAnchor.constraint(equalTo: touchImageView.bottomAnchor, constant: 20),
            longPressImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 180/844),

            threefingersImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            threefingersImageView.topAnchor.constraint(equalTo: onefingerImageView.bottomAnchor, constant: 20),
            threefingersImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 230/844),

            zoomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            zoomImageView.topAnchor.constraint(equalTo: motionImageView.bottomAnchor, constant: 20),
            zoomImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 180/844),

            fourfingersImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            fourfingersImageView.topAnchor.constraint(equalTo: twofingersImageView.bottomAnchor, constant: 20),
            fourfingersImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 230/844),

            gesturesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            gesturesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),

            fingersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            fingersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),

            fingersTopSeparator.leadingAnchor.constraint(equalTo: fingersButton.leadingAnchor),
            fingersTopSeparator.trailingAnchor.constraint(equalTo: fingersButton.trailingAnchor),
            fingersTopSeparator.bottomAnchor.constraint(equalTo: fingersButton.topAnchor),
            fingersTopSeparator.heightAnchor.constraint(equalToConstant: 1),

            fingersBottomeparator.leadingAnchor.constraint(equalTo: fingersButton.leadingAnchor),
            fingersBottomeparator.trailingAnchor.constraint(equalTo: fingersButton.trailingAnchor),
            fingersBottomeparator.topAnchor.constraint(equalTo: fingersButton.bottomAnchor),
            fingersBottomeparator.heightAnchor.constraint(equalToConstant: 1),

            gesturesBottomSeparator.leadingAnchor.constraint(equalTo: gesturesButton.leadingAnchor),
            gesturesBottomSeparator.trailingAnchor.constraint(equalTo: gesturesButton.trailingAnchor),
            gesturesBottomSeparator.topAnchor.constraint(equalTo: gesturesButton.bottomAnchor),
            gesturesBottomSeparator.heightAnchor.constraint(equalToConstant: 1),

            gesturesTopSeparator.leadingAnchor.constraint(equalTo: gesturesButton.leadingAnchor),
            gesturesTopSeparator.trailingAnchor.constraint(equalTo: gesturesButton.trailingAnchor),
            gesturesTopSeparator.bottomAnchor.constraint(equalTo: gesturesButton.topAnchor),
            gesturesTopSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc
    private func fingersButtonTapped(){
        fingersButton.isEnabled = false
        gesturesButton.isEnabled = true
        
        gesturesTextLabel.isHidden = true
        touchImageView.isHidden = true
        zoomImageView.isHidden = true
        motionImageView.isHidden = true
        longPressImageView.isHidden = true
        
        fingersTextLabel.isHidden = false
        onefingerImageView.isHidden = false
        twofingersImageView.isHidden = false
        threefingersImageView.isHidden = false
        fourfingersImageView.isHidden = false
    }
    
    @objc
    private func gesturesButtonTapped(){
        fingersButton.isEnabled = true
        gesturesButton.isEnabled = false
        
        gesturesTextLabel.isHidden = false
        touchImageView.isHidden = false
        zoomImageView.isHidden = false
        motionImageView.isHidden = false
        longPressImageView.isHidden = false
        
        fingersTextLabel.isHidden = true
        onefingerImageView.isHidden = true
        twofingersImageView.isHidden = true
        threefingersImageView.isHidden = true
        fourfingersImageView.isHidden = true
    }
}
