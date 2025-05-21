//
//  ChangePasswordViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 18.10.2024.
//

import UIKit

class ChangePasswordViewController: UIViewController{
    
    private let wasForgotten: Bool
    
    private var isOldPasswordHidden = true
    
    private var isNewPasswordHidden = true
    
    private var isRepeatPasswordHidden = true
    
    private lazy var topLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("changePassword", comment: ""))
    
    private lazy var oldPasswordLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("oldPassword", comment: ""))
    
    private lazy var newPasswordLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("newPassword", comment: ""))
    
    private lazy var repeatPasswordLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("repeatNewPassword", comment: ""))
    
    private lazy var oldPasswordTextField = MainFactory.passwordTextField(placeholder: nil)
    
    private lazy var newPasswordTextField = MainFactory.passwordTextField(placeholder: nil)
    
    private lazy var repeatPasswordTextField = MainFactory.passwordTextField(placeholder: nil)
    
    private lazy var oldPasswordButton = MainFactory.imageButtonTemplate(imageName: "showPassword")
    
    private lazy var newPasswordButton = MainFactory.imageButtonTemplate(imageName: "showPassword")
    
    private lazy var repeatPasswordButton = MainFactory.imageButtonTemplate(imageName: "showPassword")
    
    private lazy var oldPasswordSeparator = MainFactory.paleSeparator()
    
    private lazy var newPasswordSeparator = MainFactory.paleSeparator()
    
    private lazy var repeatPasswordSeparator = MainFactory.paleSeparator()
    
    private lazy var saveButton = MainFactory.mainButton(text: NSLocalizedString("saveChanges" , comment: ""))
    
    private lazy var forgotButton = MainFactory.separatedButton(text: NSLocalizedString("forgotPassword", comment: ""))
    
    private lazy var forgotButtonTopSeparator = MainFactory.separator()
    
    private lazy var forgotButtonBottomSeparator = MainFactory.separator()
    
    private var saveButtonBottomConstraint: NSLayoutConstraint?
    
    private lazy var tapGestureRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handleTap))
        recognizer.isEnabled = false
        return recognizer
    }()
    
    init(wasForgotten: Bool) {
        self.wasForgotten = wasForgotten
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topLabel)
        view.addSubview(oldPasswordLabel)
        view.addSubview(newPasswordLabel)
        view.addSubview(repeatPasswordLabel)
        view.addSubview(oldPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(oldPasswordButton)
        view.addSubview(newPasswordButton)
        view.addSubview(repeatPasswordButton)
        view.addSubview(oldPasswordSeparator)
        view.addSubview(newPasswordSeparator)
        view.addSubview(repeatPasswordSeparator)
        view.addSubview(saveButton)
        view.addSubview(forgotButton)
        view.addSubview(forgotButtonTopSeparator)
        view.addSubview(forgotButtonBottomSeparator)
        view.addGestureRecognizer(tapGestureRecognizer)
        
        forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        oldPasswordButton.addTarget(self, action: #selector(oldPasswordButtonTapped), for: .touchUpInside)
        newPasswordButton.addTarget(self, action: #selector(newPasswordButtonTapped), for: .touchUpInside)
        repeatPasswordButton.addTarget(self, action: #selector(repeatPasswordButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
                
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        
            oldPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            oldPasswordLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 52),
            
            oldPasswordTextField.topAnchor.constraint(equalTo: oldPasswordLabel.bottomAnchor),
            oldPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            oldPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            oldPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            oldPasswordSeparator.leadingAnchor.constraint(equalTo: oldPasswordTextField.leadingAnchor),
            oldPasswordSeparator.trailingAnchor.constraint(equalTo: oldPasswordTextField.trailingAnchor),
            oldPasswordSeparator.topAnchor.constraint(equalTo: oldPasswordTextField.bottomAnchor),
            oldPasswordSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            newPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            newPasswordLabel.topAnchor.constraint(equalTo: oldPasswordSeparator.bottomAnchor, constant: 33),
            
            newPasswordTextField.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor),
            newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordSeparator.leadingAnchor.constraint(equalTo: newPasswordTextField.leadingAnchor),
            newPasswordSeparator.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor),
            newPasswordSeparator.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor),
            newPasswordSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            repeatPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            repeatPasswordLabel.topAnchor.constraint(equalTo: newPasswordSeparator.bottomAnchor, constant: 33),
            
            repeatPasswordTextField.topAnchor.constraint(equalTo: repeatPasswordLabel.bottomAnchor),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            repeatPasswordSeparator.leadingAnchor.constraint(equalTo: repeatPasswordTextField.leadingAnchor),
            repeatPasswordSeparator.trailingAnchor.constraint(equalTo: repeatPasswordTextField.trailingAnchor),
            repeatPasswordSeparator.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor),
            repeatPasswordSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            forgotButton.topAnchor.constraint(equalTo: repeatPasswordSeparator.bottomAnchor, constant: 33),
            forgotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            forgotButtonTopSeparator.bottomAnchor.constraint(equalTo: forgotButton.topAnchor),
            forgotButtonTopSeparator.leadingAnchor.constraint(equalTo: forgotButton.leadingAnchor),
            forgotButtonTopSeparator.trailingAnchor.constraint(equalTo: forgotButton.trailingAnchor),
            forgotButtonTopSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            forgotButtonBottomSeparator.topAnchor.constraint(equalTo: forgotButton.bottomAnchor),
            forgotButtonBottomSeparator.leadingAnchor.constraint(equalTo: forgotButton.leadingAnchor),
            forgotButtonBottomSeparator.trailingAnchor.constraint(equalTo: forgotButton.trailingAnchor),
            forgotButtonBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 80),
            saveButtonBottomConstraint!,
            
            oldPasswordButton.trailingAnchor.constraint(equalTo: oldPasswordTextField.trailingAnchor),
            oldPasswordButton.centerYAnchor.constraint(equalTo: oldPasswordTextField.centerYAnchor),
            
            newPasswordButton.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor),
            newPasswordButton.centerYAnchor.constraint(equalTo: newPasswordTextField.centerYAnchor),
            
            repeatPasswordButton.trailingAnchor.constraint(equalTo: repeatPasswordTextField.trailingAnchor),
            repeatPasswordButton.centerYAnchor.constraint(equalTo: repeatPasswordTextField.centerYAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if wasForgotten {
            newPasswordLabel.text = NSLocalizedString("repeatNewPassword", comment: "")
            oldPasswordLabel.text = NSLocalizedString("newPassword", comment: "")
            
            repeatPasswordLabel.isHidden = true
            repeatPasswordButton.isHidden = true
            repeatPasswordTextField.isHidden = true
            repeatPasswordSeparator.isHidden = true
            forgotButton.isHidden = true
            forgotButtonTopSeparator.isHidden = true
            forgotButtonBottomSeparator.isHidden = true
        }
    }
    
    private func subscribeToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
        let keyboardHeight = keyboardFrame.cgRectValue.height
            
        saveButtonBottomConstraint?.constant = -keyboardHeight
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification){
        saveButtonBottomConstraint?.constant = -45
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            }
    }
    
    @objc
    func handleTap(){
        view.endEditing(true)
    }
    
    @objc
    func forgotButtonTapped(){
        navigationController?.pushViewController(SecurityQuestionViewController(isRecovery: true), animated: true)
    }
    
    @objc
    func oldPasswordButtonTapped(){
        isOldPasswordHidden.toggle()
        oldPasswordTextField.isSecureTextEntry.toggle()
        if isOldPasswordHidden{
            oldPasswordButton.setImage(UIImage(named: "showPassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            oldPasswordButton.setImage(UIImage(named: "hidePassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    func newPasswordButtonTapped(){
        isNewPasswordHidden.toggle()
        newPasswordTextField.isSecureTextEntry.toggle()
        if isNewPasswordHidden{
            newPasswordButton.setImage(UIImage(named: "showPassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            newPasswordButton.setImage(UIImage(named: "hidePassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    func repeatPasswordButtonTapped(){
        isRepeatPasswordHidden.toggle()
        repeatPasswordTextField.isSecureTextEntry.toggle()
        if isRepeatPasswordHidden{
            repeatPasswordButton.setImage(UIImage(named: "showPassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            repeatPasswordButton.setImage(UIImage(named: "hidePassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    func saveButtonTapped(){
        if wasForgotten {
            
        }
        else {
            
        }
    }
}
