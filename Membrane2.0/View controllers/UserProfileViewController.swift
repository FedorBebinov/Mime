//
//  UserProfileViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.02.2024.
//

import UIKit
import NVActivityIndicatorView

class UserProfileViewController: UIViewController {
    
    let service = NetworkService()
    
    private lazy var logoutButton = MainFactory.mainButton(text: "Выйти из профиля")
    
    private let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballScaleRippleMultiple, color: .textColor, padding: nil)
    
    private lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = .fontWithSize(size: 50)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .textColor
        return nameLabel
    }()
    
    private lazy var avatarView = MainFactory.avatarView()
    
    private lazy var editButton = MainFactory.circleButton(imageName: "edit")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(avatarView)
        view.addSubview(editButton)
        view.addSubview(activityIndicatorView)
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
                
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -99), logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), logoutButton.heightAnchor.constraint(equalToConstant: 80),  nameLabel.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -110), nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor), avatarView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -70), editButton.heightAnchor.constraint(equalToConstant: 55), editButton.widthAnchor.constraint(equalToConstant: 55), editButton.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -30), editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        activityIndicatorView.startAnimating()
        nameLabel.text = ""
        avatarView.avatarImageView.image = nil
        Task {
            do {
                let name = try await service.getUsername()
                await MainActor.run {
                    activityIndicatorView.stopAnimating()
                    nameLabel.text = name
                }
                
            } catch{
                print(error)
            }
        }
        
        Task {
            do {
                let avatarInfo = try await service.getAvatar()
                await MainActor.run(body: {
                    avatarView.avatarImageView.image = AvatarImage(rawValue: avatarInfo.type)?.image
                    avatarView.maskLayer.contents = avatarView.avatarImageView.image?.cgImage
                    
                    if let gradient = gradients.first(where: { gradient in gradient.name == avatarInfo.color}){
                        avatarView.apply(gradient: gradient)
                    }
                })
            } catch{
                print(error)
            }
        }
    }
    
    @objc
    func logoutButtonTapped(){
        service.deleteToken()
        navigationController?.setViewControllers([StartViewController()], animated: true)
    }
    
    @objc
    func editButtonTapped(){
        navigationController?.pushViewController(EditUserInfoViewController(), animated: true)
    }
}
