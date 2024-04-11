//
//  MenuViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 01.02.2024.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let notificationService = NotificationService.shared
    
    private var isOnboarding: Bool
    
    private var isActive = false
    
    private var tapCounter = 0
    
    private lazy var gesturesButton = MainFactory.menuButton(text: "Жесты")
    
    private lazy var profileButton = MainFactory.menuButton(text: "Профиль")
    
    private lazy var changingButton = MainFactory.circleButton(imageName: "plus")
    
    private lazy var createRoomButton = MainFactory.menuButton(text: "Создать комнату")
    
    private lazy var enterRoomButton = MainFactory.menuButton(text: "Войти в комнату")
    
    private lazy var skipOnboardingButton = MainFactory.separatedButton(text: "Пропустить обучение")
    
    private lazy var topSeparator = MainFactory.separator()
    
    private lazy var bottomSeparator = MainFactory.separator()
    
    private lazy var textLabel = MainFactory.gestureTextLabel(text: "Добро пожаловать в Mime! Нажмите кнопку, чтобы начать общаться")
    
    private lazy var nextButton = MainFactory.mainButton(text: "Далее")
    
    private lazy var menuStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [gesturesButton, profileButton, changingButton, createRoomButton, enterRoomButton])
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
        
        
        gesturesButton.addTarget(self, action: #selector(gesturesButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        changingButton.addTarget(self, action: #selector(changingButtonTapped), for: .touchUpInside)
        createRoomButton.addTarget(self, action: #selector(createRoomButtonTapped), for: .touchUpInside)
        enterRoomButton.addTarget(self, action: #selector(enterRoomButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        skipOnboardingButton.addTarget(self, action: #selector(skipOnboardingButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([menuStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor), menuStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor), skipOnboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5), skipOnboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100), skipOnboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100), topSeparator.bottomAnchor.constraint(equalTo: skipOnboardingButton.topAnchor), topSeparator.heightAnchor.constraint(equalToConstant: 1), topSeparator.leadingAnchor.constraint(equalTo: skipOnboardingButton.leadingAnchor), topSeparator.trailingAnchor.constraint(equalTo: skipOnboardingButton.trailingAnchor), bottomSeparator.topAnchor.constraint(equalTo: skipOnboardingButton.bottomAnchor), bottomSeparator.heightAnchor.constraint(equalToConstant: 1), bottomSeparator.leadingAnchor.constraint(equalTo: skipOnboardingButton.leadingAnchor), bottomSeparator.trailingAnchor.constraint(equalTo: skipOnboardingButton.trailingAnchor), textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40), textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nextButton.bottomAnchor.constraint(equalTo: topSeparator.topAnchor, constant: -20), nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), nextButton.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([gesturesButton.heightAnchor.constraint(equalToConstant: 51), profileButton.heightAnchor.constraint(equalToConstant: 51), createRoomButton.heightAnchor.constraint(equalToConstant: 51), enterRoomButton.heightAnchor.constraint(equalToConstant: 51), changingButton.heightAnchor.constraint(equalToConstant: 55), changingButton.widthAnchor.constraint(equalToConstant: 55)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc
    private func changingButtonTapped(){
        isActive.toggle()
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
        animator.addAnimations {
            self.gesturesButton.isHidden = !self.isActive
            self.profileButton.isHidden = !self.isActive
            self.createRoomButton.isHidden = !self.isActive
            self.enterRoomButton.isHidden = !self.isActive
            if self.isActive{
                self.changingButton.setImage(UIImage(named: "cancel"), for: .normal)
            } else {
                self.changingButton.setImage(UIImage(named: "plus"), for: .normal)
            }
        }
        animator.startAnimation()
        
        if isOnboarding && tapCounter == 0 {
            textLabel.text = "Кнопка \"Жесты\" является кнопкой помощи, в которой описаны все жесты, применяемые в приложении"
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
    private func skipOnboardingButtonTapped(){
        isOnboarding = false
        skipOnboardingButton.isHidden = !isOnboarding
        topSeparator.isHidden = !isOnboarding
        bottomSeparator.isHidden = !isOnboarding
        textLabel.isHidden = !isOnboarding
        nextButton.isHidden = true
        
        gesturesButton.isEnabled = true
        profileButton.isEnabled = true
        createRoomButton.isEnabled = true
        enterRoomButton.isEnabled = true
        changingButton.isEnabled = true
    }

    
    @objc
    private func nextButtonTapped(){
        switch tapCounter{
        case 1:
            gesturesButton.isEnabled = false
            profileButton.isEnabled = true
            textLabel.text = "Кнопка \"Профиль\" открывает всю информацию о вашем аккаунте с возможностью ее редактировать"
        case 2:
            profileButton.isEnabled = false
            createRoomButton.isEnabled = true
            textLabel.text = "Кнопка \"Создать комнату\" создает комнату, к которой может присоединиться ваш собеседник. Во время ожидания можно потренировать использование жестов"
        case 3:
            createRoomButton.isEnabled = false
            enterRoomButton.isEnabled = true
            textLabel.text = "Кнопка \"Войти в комнату\" позволяет войти в комнату, созданную вашим собеседником с помощью переданного кода"
        case 4:
            navigationController?.pushViewController(CallViewController(isEnter: true, isOnboarding: true, roomId: nil), animated: true)
        default:
            return
        }
        tapCounter += 1
    }
}
