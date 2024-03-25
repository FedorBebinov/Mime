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
    
    private lazy var topSeparator = MainFactory.separator()
    
    private lazy var bottomSeparator = MainFactory.separator()
    
    private lazy var nameTextField = MainFactory.textFieldWithPlaceholder(placeholder: "Логин")
    
    private lazy var passwordTextField = MainFactory.textFieldWithPlaceholder(placeholder: "Пароль")
    
    private lazy var actionButton = MainFactory.mainButton(text: buttonText)
    
    private lazy var passwordButton = MainFactory.imageButton(imageName: "showPassword")
    
    let isLogin: Bool
    let labelText: String
    let buttonText: String
    
    
    init(isLogin: Bool) {
        self.isLogin = isLogin
        if isLogin {
            labelText = "Вход"
            buttonText = "Войти"
        } else {
            labelText = "Регистрация"
            buttonText = "Зарегестрироваться"
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 98), nameTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(passwordTextField)
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
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    private func isPasswordStrongEnough(password: String) -> Bool {
        let passRegEx = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}"
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
    func actionButtonTapped(){
        guard let name = nameTextField.text, let password = passwordTextField.text, !name.isEmpty, !password.isEmpty else{
            errorAlert(tittle: "Ошибка", message: "Логин и пароль не должны быть пустыми")
            return
        }
        
        guard isPasswordStrongEnough(password: password) else{
            errorAlert(tittle: "Пароль недостаточно сложный", message: "Пароль должен содежать цифру, заглавную букву и содержать как мининмум 8 символов")
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
                                errorAlert(tittle: "Ошибка", message: "Пользователя с таким никнеймом не существует")
                                return
                            })
                        } catch AuthorizationError.wrongPassword {
                            await MainActor.run(body: {
                                errorAlert(tittle: "Ошибка", message: "Неверный пароль или логин пользователя")
                                return
                                })
                        } catch BackendError.badResponse {
                            await MainActor.run(body: {
                                errorAlert(tittle: "Ошибка", message: "Сервер не отвечает")
                                return
                                })
                        } catch {
                            await MainActor.run(body: {
                                errorAlert(tittle: "Ошибка", message: "Что-то пошло не так")
                                return
                                })
                        }
                    } else {
                        do{
                            try await service.register(data: user)
                            await MainActor.run {navigationController?.pushViewController(ChooseShapeViewController(), animated: true)}
                        } catch AuthorizationError.userAlreadyExists {
                            await MainActor.run(body: {
                                errorAlert(tittle: "Ошибка", message: "Пользователь с таким никнеймом уже существует")
                                return
                                })
                            } catch BackendError.badResponse {
                                await MainActor.run(body: {
                                    errorAlert(tittle: "Ошибка", message: "Сервер не отвечает")
                                    return
                                    })
                            } catch {
                                await MainActor.run(body: {
                                    errorAlert(tittle: "Ошибка", message: "Что-то пошло не так")
                                    return
                                    })
                            }
                    }
            }
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
}
