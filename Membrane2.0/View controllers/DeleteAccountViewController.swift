//
//  DeleteAccountViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.10.2024.
//

import UIKit

class DeleteAccountViewController: UIViewController{
    
    private let networkService = NetworkService()
    
    private var isPasswordHidden = true
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    private var deleteButtonBottomConstraint: NSLayoutConstraint?

    private lazy var topLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("enterPassword", comment: ""))
    
    private lazy var passwordLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("accountPassword", comment: ""))
    
    private lazy var passwordTextField = MainFactory.passwordTextField(placeholder: nil)
    
    private lazy var passwordSeparator = MainFactory.paleSeparator()
    
    private lazy var precautionaryLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("warning", comment: ""))
    
    private lazy var passwordButton: UIButton = {
        let image = UIImage(resource: .showPassword).withRenderingMode(.alwaysTemplate)
        let button = MainFactory.imageButton(image: image)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteAccountButton = MainFactory.redMainButton(text: NSLocalizedString("deleteAccount", comment: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(topLabel)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSeparator)
        view.addSubview(deleteAccountButton)
        view.addSubview(precautionaryLabel)
        view.addSubview(passwordButton)
        
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        
        
        deleteButtonBottomConstraint = deleteAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 29),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordSeparator.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordSeparator.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            passwordSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 80),
            deleteButtonBottomConstraint!,
            
            precautionaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            precautionaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            precautionaryLabel.topAnchor.constraint(equalTo: passwordSeparator.bottomAnchor, constant: 15),
            
            passwordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            passwordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor)
        ])
        
        subscribeToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func passwordButtonTapped(){
        isPasswordHidden.toggle()
        passwordTextField.isSecureTextEntry.toggle()
        if isPasswordHidden{
            passwordButton.setImage(UIImage(named: "showPassword"), for: .normal)
        } else {
            passwordButton.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
    }
    
    @objc
    func deleteAccountButtonTapped(){
        Task {
            do{
                try await networkService.deleteAccount()
                await MainActor.run {
                    _ = navigationController?.popToRootViewController(animated: true)
                }
            } catch {
                print(error)
            }
        }
    }
                                               
    @objc
    func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
        let keyboardHeight = keyboardFrame.cgRectValue.height
            
        deleteButtonBottomConstraint?.constant = -(keyboardHeight + 20) // Поднятие textField
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification){
        deleteButtonBottomConstraint?.constant = -45
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            }
    }
    
    @objc
    func handleTap(){
        view.endEditing(true)
    }
    
}
