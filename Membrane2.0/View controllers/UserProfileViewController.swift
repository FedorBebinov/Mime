//
//  UserProfileViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.02.2024.
//

import UIKit
import NVActivityIndicatorView

class UserProfileViewController: UIViewController {
    
    private let service = NetworkService()
    
    private lazy var achievementsButton = MainFactory.mainButton(text: "Мои достижения")
    
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
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(achievementsButton)
        view.addSubview(nameLabel)
        view.addSubview(avatarView)
        view.addSubview(editButton)
        view.addSubview(activityIndicatorView)
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
                
        achievementsButton.addTarget(self, action: #selector(achievementsButtonTapped), for: .touchUpInside)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([achievementsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -99), achievementsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), achievementsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), achievementsButton.heightAnchor.constraint(equalToConstant: 80),  nameLabel.bottomAnchor.constraint(equalTo: achievementsButton.topAnchor, constant: -110), nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor), avatarView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -70), editButton.heightAnchor.constraint(equalToConstant: 55), editButton.widthAnchor.constraint(equalToConstant: 55), editButton.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -30), editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsButton"), style: .plain, target: self, action: #selector(settingsButtonTapped))
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
    private func achievementsButtonTapped(){
        navigationController?.pushViewController(AchievementsViewController(), animated: true)
    }
    
    @objc
    private func editButtonTapped(){
        navigationController?.pushViewController(EditUserInfoViewController(), animated: true)
    }
    
    @objc
    private func settingsButtonTapped(){
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
