//
//  MenuViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 01.02.2024.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let ac = AchievementService()
    
    private let notificationService = NotificationService.shared
    
    private var isOnboarding: Bool
    
    private var isActive = false
    
    private var tapCounter = 0
    
    private var nameAvatarViews = [NameAvatarView]()
    
    private lazy var donateButton = MainFactory.menuButton(text: NSLocalizedString("supportProject", comment: ""))
    
    private lazy var profileButton = MainFactory.menuButton(text: NSLocalizedString("profile", comment: ""))
    
    private lazy var changingButton = MainFactory.circleButton(imageName: "plus")
    
    private lazy var createRoomButton = MainFactory.menuButton(text: NSLocalizedString("createRoom", comment: ""))
    
    private lazy var enterRoomButton = MainFactory.menuButton(text: NSLocalizedString("enterRoom", comment: ""))
    
    private lazy var skipOnboardingButton = MainFactory.separatedButton(text: NSLocalizedString("skipTutorial", comment: ""))
    
    private lazy var topSeparator = MainFactory.separator()
    
    private lazy var bottomSeparator = MainFactory.separator()
    
    private lazy var textLabel = MainFactory.gestureTextLabel(text: NSLocalizedString("welcome", comment: ""))
    
    private lazy var nextButton = MainFactory.mainButton(text: NSLocalizedString("next", comment: ""))
    
    private lazy var menuStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [donateButton, profileButton, changingButton, createRoomButton, enterRoomButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .center
        return stackView
    }()
    
    init(isOnboarding: Bool) {
        self.isOnboarding = isOnboarding
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        notificationService.addNotification()
        
        ac.getAchievements()
        
        /*var interlocutors = [LastInterlocutors(name: "OGTarget", avatarType: "door" , gradientName: "grayWhite", roomId: "SASD"), LastInterlocutors(name: "IlyaBB", avatarType: "drum" , gradientName: "purplePink", roomId: "SASD"), LastInterlocutors(name: "NekMMM", avatarType: "shield" , gradientName: "pinkWhite", roomId: "SASD"), LastInterlocutors(name: "Fedorer", avatarType: "spinner" , gradientName: "yellowOrange", roomId: "SASD")]
        UserDefaults.standard.interlocutors = interlocutors*/
        
        view.addSubview(menuStackView)
        view.addSubview(skipOnboardingButton)
        view.addSubview(topSeparator)
        view.addSubview(bottomSeparator)
        view.addSubview(textLabel)
        view.addSubview(nextButton)
        
        skipOnboardingButton.isHidden = !isOnboarding
        topSeparator.isHidden = !isOnboarding
        bottomSeparator.isHidden = !isOnboarding
        textLabel.isHidden = !isOnboarding
        nextButton.isHidden = true
        
        
        donateButton.addTarget(self, action: #selector(donateButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        changingButton.addTarget(self, action: #selector(changingButtonTapped), for: .touchUpInside)
        createRoomButton.addTarget(self, action: #selector(createRoomButtonTapped), for: .touchUpInside)
        enterRoomButton.addTarget(self, action: #selector(enterRoomButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        skipOnboardingButton.addTarget(self, action: #selector(skipOnboardingButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            menuStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            menuStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipOnboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            skipOnboardingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            topSeparator.bottomAnchor.constraint(equalTo: skipOnboardingButton.topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            topSeparator.leadingAnchor.constraint(equalTo: skipOnboardingButton.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: skipOnboardingButton.trailingAnchor),
            
            bottomSeparator.topAnchor.constraint(equalTo: skipOnboardingButton.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparator.leadingAnchor.constraint(equalTo: skipOnboardingButton.leadingAnchor), 
            bottomSeparator.trailingAnchor.constraint(equalTo: skipOnboardingButton.trailingAnchor),
            
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            nextButton.bottomAnchor.constraint(equalTo: topSeparator.topAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 80),
            
            donateButton.heightAnchor.constraint(equalToConstant: 51),
            profileButton.heightAnchor.constraint(equalToConstant: 51),
            createRoomButton.heightAnchor.constraint(equalToConstant: 51),
            enterRoomButton.heightAnchor.constraint(equalToConstant: 51),
            changingButton.heightAnchor.constraint(equalToConstant: 55),
            changingButton.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        addNameAvatarViews()
        AchievementService.shared.checkAppLaunch()
    }
    
    private func addNameAvatarViews(){
        
        for nameAvatarView in nameAvatarViews {
            nameAvatarView.removeFromSuperview()
        }
        nameAvatarViews.removeAll()

        for (index, interlocutor) in UserDefaults.standard.interlocutors.enumerated() {
            let avatarView = NameAvatarView()
            avatarView.alpha = self.isActive ? 0 : 1
            avatarView.tapHandler = {
                self.navigationController?.pushViewController(CallViewController(isEnter: true, isOnboarding: false, roomId: interlocutor.roomId), animated: true)
            }
            avatarView.name.text = interlocutor.name
            view.addSubview(avatarView)
            avatarView.layer.shadowColor = CGColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)
            avatarView.layer.shadowRadius = 10.0
            avatarView.layer.shadowOpacity = 1
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            switch index {
            case 0:
                NSLayoutConstraint.activate([
                    avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
                    avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -100)])
                
                avatarView.transform = .init(rotationAngle: 0.55).scaledBy(x: 0.8, y: 0.8)
                
            case 1:
                NSLayoutConstraint.activate([
                    avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
                    avatarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100)])
            
                avatarView.transform = .init(rotationAngle: 0.17).scaledBy(x: 0.8, y: 0.8)
                
            case 2:
                NSLayoutConstraint.activate([
                    avatarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                    avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -100)])
                
                avatarView.transform = .init(rotationAngle: -0.31).scaledBy(x: 0.8, y: 0.8)
                
            case 3:
                NSLayoutConstraint.activate([
                    avatarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                    avatarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100)])
                
                avatarView.transform = .init(rotationAngle: -0.26).scaledBy(x: 0.8, y: 0.8)
            default:
                break
            }
            
            if let gradient = gradients.first(where: { gradient in gradient.name == interlocutor.gradientName}) {
                avatarView.apply(gradient: gradient)
        }
            let image = AvatarImage(rawValue: interlocutor.avatarType)?.image
            avatarView.avatarImageView.image = image
            avatarView.applyMask(image: image)
            nameAvatarViews.append(avatarView)
        }
    }
    
    @objc
    private func changingButtonTapped(){
        isActive.toggle()
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
        animator.addAnimations {
            self.donateButton.isHidden = !self.isActive
            self.profileButton.isHidden = !self.isActive
            self.createRoomButton.isHidden = !self.isActive
            self.enterRoomButton.isHidden = !self.isActive
            for nameAvatarView in self.nameAvatarViews {
                nameAvatarView.alpha = self.isActive ? 0 : 1
            }
            if self.isActive{
                self.changingButton.setImage(UIImage(named: "cancel"), for: .normal)
            } else {
                self.changingButton.setImage(UIImage(named: "plus"), for: .normal)
            }
        }
        animator.startAnimation()
        
        if isOnboarding && tapCounter == 0 {
            textLabel.text = NSLocalizedString("menuSupport", comment: "")
            profileButton.isEnabled = false
            createRoomButton.isEnabled = false
            enterRoomButton.isEnabled = false
            changingButton.isEnabled = false
            tapCounter += 1
            nextButton.isHidden = false
        }
    }
    
    @objc
    private func profileButtonTapped(){
        navigationController?.pushViewController(UserProfileViewController(), animated: true)
    }
    
    @objc
    private func enterRoomButtonTapped(){
        navigationController?.pushViewController(EnterRoomViewController(), animated: true)
    }
    
    @objc
    private func createRoomButtonTapped(){
        navigationController?.pushViewController(CallViewController(isEnter: false, isOnboarding: false, roomId: nil), animated: true)
    }
    
    @objc
    private func gesturesButtonTapped(){
        navigationController?.pushViewController(GesturesViewController(), animated: true)
    }
    
    @objc
    private func donateButtonTapped(){
        navigationController?.pushViewController(DonationViewController(), animated: true)
    }
    
    @objc
    private func skipOnboardingButtonTapped(){
        isOnboarding = false
        skipOnboardingButton.isHidden = !isOnboarding
        topSeparator.isHidden = !isOnboarding
        bottomSeparator.isHidden = !isOnboarding
        textLabel.isHidden = !isOnboarding
        nextButton.isHidden = true
        
        donateButton.isEnabled = true
        profileButton.isEnabled = true
        createRoomButton.isEnabled = true
        enterRoomButton.isEnabled = true
        changingButton.isEnabled = true
    }

    
    @objc
    private func nextButtonTapped(){
        switch tapCounter{
        case 1:
            donateButton.isEnabled = false
            profileButton.isEnabled = true
            textLabel.text = NSLocalizedString("menuProfile", comment: "")
        case 2:
            profileButton.isEnabled = false
            createRoomButton.isEnabled = true
            textLabel.text = NSLocalizedString("menuCreateRoom", comment: "")
        case 3:
            createRoomButton.isEnabled = false
            enterRoomButton.isEnabled = true
            textLabel.text = NSLocalizedString("menuJoinRoom", comment: "")
        case 4:
            navigationController?.pushViewController(CallViewController(isEnter: true, isOnboarding: true, roomId: nil), animated: true)
        default:
            return
        }
        tapCounter += 1
    }
}
