//
//  LoginCheckViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 11.10.2024.
//

import UIKit

class LoginCheckViewController: UIViewController {
    
    private lazy var topLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("enterLogin", comment: ""))
    
    private lazy var loginLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("login", comment: ""))
    
    private lazy var loginTextField = MainFactory.textField()
    
    private lazy var loginSeparator = MainFactory.paleSeparator()
    
    private lazy var continueButton = MainFactory.disabledMainButton(text: NSLocalizedString("continue", comment: ""))
    
    private var continueButtonBottomConstraint: NSLayoutConstraint?
    
    private lazy var tapGestureRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handleTap))
        recognizer.isEnabled = false
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topLabel)
        view.addSubview(loginLabel)
        view.addSubview(loginTextField)
        view.addSubview(loginSeparator)
        view.addSubview(continueButton)
        view.addGestureRecognizer(tapGestureRecognizer)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        loginTextField.delegate = self
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
        continueButtonBottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 52),
            
            loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginSeparator.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            loginSeparator.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            loginSeparator.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            loginSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 80),
            continueButtonBottomConstraint!,
        ])
        
        subscribeToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func updateButtonState() {
        continueButton.isEnabled = !(loginTextField.text?.isEmpty ?? true)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
        let keyboardHeight = keyboardFrame.cgRectValue.height
            
        continueButtonBottomConstraint?.constant = -keyboardHeight
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification){
        continueButtonBottomConstraint?.constant = -45
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            }
    }
    
    @objc
    func handleTap(){
        view.endEditing(true)
    }
    
    @objc
    func continueButtonTapped(){
        navigationController?.pushViewController(SecurityQuestionViewController(isRecovery: true), animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            if let text = textField.text, !text.isEmpty {
                continueButton.isEnabled = true
            } else {
                continueButton.isEnabled = false
            }
        }
}

extension LoginCheckViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        continueButtonTapped()
        return true
    }
}

