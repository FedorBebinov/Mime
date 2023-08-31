//
//  MainViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 22.08.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var doorAvatar: AvatarView = {
        var avatar = AvatarView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.doorImageView.image = UIImage(named: "door")
        avatar.maskLayer.contents = avatar.doorImageView.image?.cgImage
        avatar.gradient.colors = [UIColor(red: 255/255, green: 154/255, blue: 158/255, alpha: 1).cgColor, UIColor(red: 250/255, green: 208/255, blue: 196/255, alpha: 1).cgColor, UIColor(red: 250/255, green: 208/255, blue: 196/255, alpha: 1).cgColor]
        avatar.gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        avatar.gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return avatar
    }()
    
    private lazy var spinnerAvatar: AvatarView = {
        var avatar = AvatarView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.doorImageView.image = UIImage(named: "spinner")
        avatar.maskLayer.contents = avatar.doorImageView.image?.cgImage
        avatar.gradient.colors = [UIColor(red: 255/255, green: 152/255, blue: 158/255, alpha: 1).cgColor, UIColor(red: 79/255, green: 96/255, blue: 255/255, alpha: 1).cgColor]
        avatar.gradient.startPoint = CGPoint(x: 0.3, y: 0.0)
        avatar.gradient.endPoint = CGPoint(x: 0.7, y: 1.0)
        return avatar
    }()
    
    private lazy var createRoomButton: UIButton = {
        var createRoomButton = UIButton()
        createRoomButton.layer.cornerRadius = 40
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.fontWithSize(size: 18)!
        ]
        let attributedString = NSAttributedString(string: "Создать комнату", attributes: attributes)
        createRoomButton.setAttributedTitle(attributedString, for: .normal)
        createRoomButton.translatesAutoresizingMaskIntoConstraints = false
        createRoomButton.setTitleColor(.textColor, for: .normal)
        createRoomButton.backgroundColor = .buttonColor
        createRoomButton.addTarget(self, action: #selector(createRoomButtonTapped), for: .touchUpInside)
        return createRoomButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(createRoomButton)
        NSLayoutConstraint.activate([createRoomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), createRoomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), createRoomButton.widthAnchor.constraint(equalToConstant: 350), createRoomButton.heightAnchor.constraint(equalToConstant: 80)])
        
        view.addSubview(doorAvatar)
        NSLayoutConstraint.activate([doorAvatar.topAnchor.constraint(equalTo: createRoomButton.bottomAnchor, constant: 20), doorAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor), doorAvatar.widthAnchor.constraint(equalToConstant: 182), doorAvatar.heightAnchor.constraint(equalToConstant: 305)])
        
        view.addSubview(spinnerAvatar)
        NSLayoutConstraint.activate([spinnerAvatar.topAnchor.constraint(equalTo: doorAvatar.bottomAnchor, constant: 20), spinnerAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor), spinnerAvatar.widthAnchor.constraint(equalToConstant: 268), spinnerAvatar.heightAnchor.constraint(equalToConstant: 247)])
        
    }
    
    @objc
    func createRoomButtonTapped(){
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}
