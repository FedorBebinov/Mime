//
//  ViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 21.08.2023.
//

import UIKit
import NVActivityIndicatorView

class AuthorizationViewController: UIViewController {
    
    private let service = NetworkService()
    
    private let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballScaleRippleMultiple, color: .textColor, padding: nil)
    
    private var isPasswordHidden = true
    
    private lazy var loadingView = MainFactory.loadingView()
    
    private lazy var nameLabel = MainFactory.topLabel(text: labelText)
    
    private lazy var topSeparator = MainFactory.paleSeparator()
    
    private lazy var bottomSeparator = MainFactory.paleSeparator()
    
    private lazy var nameTextField = MainFactory.textFieldLogin(placeholder: NSLocalizedString("login", comment: ""))
    
    private lazy var passwordTextField = MainFactory.textFieldLogin(placeholder: NSLocalizedString("password", comment: ""))
    
    private lazy var actionButton = MainFactory.mainButton(text: buttonText)
    
    private lazy var passwordButton = MainFactory.imageButtonTemplate(imageName: "showPassword")
    
    private lazy var forgottenPasswordButton = MainFactory.separatedButton(text: NSLocalizedString("forgotPassword", comment: ""))
    
    private lazy var forgotTopSeparator = MainFactory.separator()
    
    private lazy var forgotBottomSeparator = MainFactory.separator()
    
    private let isLogin: Bool
    private let labelText: String
    private let buttonText: String
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
        if isLogin {
            labelText = NSLocalizedString("entrance", comment: "")
            buttonText = NSLocalizedString("enter", comment: "")
        } else {
            labelText = NSLocalizedString("registration", comment: "")
            buttonText = NSLocalizedString("register", comment: "")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.tintColor = .textColor
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)])
        
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        NSLayoutConstraint.activate([nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 88), nameTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        NSLayoutConstraint.activate([passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16), passwordTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate(
            [actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), actionButton.heightAnchor.constraint(equalToConstant: 80), actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 80)])
        
        view.addSubview(topSeparator)
        NSLayoutConstraint.activate([topSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor), topSeparator.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor), topSeparator.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor), topSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(bottomSeparator)
        NSLayoutConstraint.activate([bottomSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor), bottomSeparator.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor), bottomSeparator.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor), bottomSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(passwordButton)
        passwordButton.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([passwordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor), passwordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor)])
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor), activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([loadingView.topAnchor.constraint(equalTo: view.topAnchor), loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor), loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor), loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        view.addSubview(forgottenPasswordButton)
        forgottenPasswordButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            forgottenPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgottenPasswordButton.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 20)
        ])
        
        view.addSubview(forgotTopSeparator)
        NSLayoutConstraint.activate(
            [forgotTopSeparator.bottomAnchor.constraint(equalTo: forgottenPasswordButton.topAnchor),
             forgotTopSeparator.leadingAnchor.constraint(equalTo: forgottenPasswordButton.leadingAnchor),
             forgotTopSeparator.trailingAnchor.constraint(equalTo: forgottenPasswordButton.trailingAnchor),
             forgotTopSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(forgotBottomSeparator)
        NSLayoutConstraint.activate(
            [forgotBottomSeparator.topAnchor.constraint(equalTo: forgottenPasswordButton.bottomAnchor),
             forgotBottomSeparator.leadingAnchor.constraint(equalTo: forgottenPasswordButton.leadingAnchor),
             forgotBottomSeparator.trailingAnchor.constraint(equalTo: forgottenPasswordButton.trailingAnchor),
             forgotBottomSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        nameTextField.becomeFirstResponder()
        
        if !isLogin{
            forgottenPasswordButton.isHidden = true
            forgotTopSeparator.isHidden = true
            forgotBottomSeparator.isHidden = true
        }
    }
    
    private func isPasswordStrongEnough(password: String) -> Bool {
        let passRegEx = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    private func errorAlert(tittle:String, message: String){
        activityIndicatorView.stopAnimating()
        loadingView.isHidden = true
        let allert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "OK", style: .default))
        present(allert, animated: true)
    }
    
    @objc
    private func actionButtonTapped(){
        guard let name = nameTextField.text, let password = passwordTextField.text, !name.isEmpty, !password.isEmpty else{
            errorAlert(tittle: NSLocalizedString("error", comment: ""), message: "Логин и пароль не должны быть пустыми")
            return
        }
        
        guard isPasswordStrongEnough(password: password) else{
            errorAlert(tittle: "Пароль недостаточно сложный", message: "Пароль должен содежать цифру, заглавную букву и содержать как мининмум 6 символов")
            return
        }
            let user: UserData = UserData(username: name, password: password)
        activityIndicatorView.startAnimating()
        loadingView.isHidden = false
            Task {
                    if isLogin{
                        do{
                            try await service.login(data: user)
                            await MainActor.run {
                                navigationController?.pushViewController(MenuViewController(isOnboarding: false), animated: true)
                            }
                        } catch AuthorizationError.userDoesNotExist {
                            await MainActor.run(body: {
                                errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("logNotExist", comment: ""))
                                return
                            })
                        } catch AuthorizationError.wrongPassword {
                            await MainActor.run(body: {
                                errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("wrongAuth", comment: ""))
                                return
                                })
                        } catch BackendError.badResponse {
                            await MainActor.run(body: {
                                errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("serverDisable", comment: ""))
                                return
                                })
                        } catch {
                            await MainActor.run(body: {
                                errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("smthWentWrong", comment: ""))
                                return
                                })
                        }
                    } else {
                        do{
                            try await service.register(data: user)
                            await MainActor.run {navigationController?.pushViewController(SecurityQuestionViewController(isRecovery: false), animated: true)}
                        } catch AuthorizationError.userAlreadyExists {
                            await MainActor.run(body: {
                                errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("logAlreadyExis", comment: ""))
                                return
                                })
                            } catch BackendError.badResponse {
                                await MainActor.run(body: {
                                    errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("serverDisable", comment: ""))
                                    return
                                    })
                            } catch {
                                await MainActor.run(body: {
                                    errorAlert(tittle: NSLocalizedString("error", comment: ""), message: NSLocalizedString("smthWentWrong", comment: ""))
                                    return
                                    })
                            }
                    }
            }
    }
    
    @objc
    private func passwordButtonTapped(){
        isPasswordHidden.toggle()
        passwordTextField.isSecureTextEntry.toggle()
        if isPasswordHidden{
            passwordButton.setImage(UIImage(named: "showPassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            passwordButton.setImage(UIImage(named: "hidePassword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    private func forgotButtonTapped(){
        navigationController?.pushViewController(LoginCheckViewController(), animated: true)
    }
}

extension AuthorizationViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            actionButtonTapped()
        }
        return true
    }
}

