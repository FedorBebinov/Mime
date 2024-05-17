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
    
    private lazy var achievementsButton = MainFactory.mainButton(text: NSLocalizedString("myAchievements", comment: ""))
    
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
        navigationController?.navigationBar.tintColor = .textColor
        
        view.addSubview(achievementsButton)
        view.addSubview(nameLabel)
        view.addSubview(avatarView)
        view.addSubview(editButton)
        view.addSubview(activityIndicatorView)
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
                
        achievementsButton.addTarget(self, action: #selector(achievementsButtonTapped), for: .touchUpInside)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        print(UIScreen.main.bounds)
        let topInset: CGFloat = UIScreen.main.bounds.height <= 736 ? 30 : 70
        
        NSLayoutConstraint.activate([achievementsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16), achievementsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), achievementsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), achievementsButton.heightAnchor.constraint(equalToConstant: 80),  nameLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 30), nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor), avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset), editButton.heightAnchor.constraint(equalToConstant: 55), editButton.widthAnchor.constraint(equalToConstant: 55), editButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40), editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsButton"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        avatarView.alpha = 0
        editButton.alpha = 0
        activityIndicatorView.startAnimating()
        nameLabel.alpha = 0
        avatarView.avatarImageView.image = nil
        Task {
            do {
                let name = try await service.getUsername()
                let avatarInfo = try await service.getAvatar()
                await MainActor.run {
                    activityIndicatorView.stopAnimating()
                    self.nameLabel.text = name

                    avatarView.avatarImageView.image = AvatarImage(rawValue: avatarInfo.type)?.image
                    avatarView.maskLayer.contents = avatarView.avatarImageView.image?.cgImage

                    if let gradient = gradients.first(where: { gradient in gradient.name == avatarInfo.color}){
                        avatarView.apply(gradient: gradient)
                    }
                    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
                    animator.addAnimations {
                        self.nameLabel.alpha = 1
                        self.editButton.alpha = 1
                        self.avatarView.alpha = 1
                    }
                    animator.startAnimation(afterDelay: 0.3)
                }
                
            } catch{
                print(error)
            }
        }

        if UserDefaults.standard.borderEnabled {
            avatarView.avatarImageView.layer.shadowColor = UIColor.avatarBorderColor.cgColor
            avatarView.avatarImageView.layer.shadowOpacity = 1
            avatarView.avatarImageView.layer.shadowOffset = .zero
            avatarView.avatarImageView.layer.shadowRadius = 25
        } else {
            avatarView.avatarImageView.layer.shadowOpacity = 0
        }
    }
    
    @objc
    private func achievementsButtonTapped(){
        navigationController?.pushViewController(AchievementsViewController(), animated: true)
    }
    
    @objc
    private func editButtonTapped(){
        navigationController?.pushViewController(EditUserInfoViewController(username: nameLabel.text ?? ""), animated: true)
    }
    
    @objc
    private func settingsButtonTapped(){
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
