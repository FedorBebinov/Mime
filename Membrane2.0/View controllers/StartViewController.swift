//
//  StartViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 06.12.2023.
//

import UIKit

class StartViewController: UIViewController{
    
    private lazy var loginButton = MainFactory.mainButton(text: "Вход")
    
    private lazy var registerButton = MainFactory.separatedButton(text: "Регистрация")
    
    private lazy var welcomeImage = MainFactory.imageView(name: "enterImage")
    
    private lazy var topLine = MainFactory.separator()
    
    private lazy var bottomLine = MainFactory.separator()
    
    private lazy var mimeImage = MainFactory.imageView(name: "mime")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(welcomeImage)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(topLine)
        view.addSubview(bottomLine)
        view.addSubview(mimeImage)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([welcomeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), welcomeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), welcomeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40), loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), loginButton.heightAnchor.constraint(equalToConstant: 80), loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -20), registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20), registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), topLine.bottomAnchor.constraint(equalTo: registerButton.topAnchor), topLine.widthAnchor.constraint(equalTo: registerButton.widthAnchor, multiplier: 1), topLine.heightAnchor.constraint(equalToConstant: 1), topLine.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor), bottomLine.topAnchor.constraint(equalTo: registerButton.bottomAnchor), bottomLine.widthAnchor.constraint(equalTo: registerButton.widthAnchor, multiplier: 1), bottomLine.heightAnchor.constraint(equalToConstant: 1), bottomLine.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor), mimeImage.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: 35), mimeImage.centerXAnchor.constraint(equalTo: welcomeImage.centerXAnchor)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    
    @objc
    func loginButtonTapped(){
        navigationController?.pushViewController(AuthorizationViewController(isLogin: true), animated: true)
    }
    
    @objc
    func registerButtonTapped(){
        navigationController?.pushViewController(AuthorizationViewController(isLogin: false), animated: true)
    }
}
