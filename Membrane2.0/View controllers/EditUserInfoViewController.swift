//
//  EditUserInfoViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.02.2024.
//

import UIKit
import NVActivityIndicatorView

class EditUserInfoViewController: UIViewController{
    
    private let service = NetworkService()
    
    private var isPasswordHidden = true
    
    private let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 50), type: .ballBeat, color: .textColor, padding: nil)
    
    private lazy var editLabel = MainFactory.topLabel(text: NSLocalizedString("profileEdit", comment: ""))
    
    private lazy var nameLabel = MainFactory.miniLabel(text: NSLocalizedString("login", comment: ""))
    
    private lazy var passwordLabel = MainFactory.miniLabel(text: NSLocalizedString("password", comment: ""))
    
    private lazy var avatarLabel = MainFactory.miniLabel(text: NSLocalizedString("avatar", comment: ""))
    
    private lazy var avatarTextLabel = MainFactory.changeLabel(text: NSLocalizedString("chooseAnother", comment: ""))
    
    private lazy var nameSeparator = MainFactory.paleSeparator()
    
    private lazy var oldPasswordSeparator = MainFactory.paleSeparator()
        
    private lazy var avatarSeparator = MainFactory.paleSeparator()
    
    private lazy var topNameSeparator = MainFactory.separator()
    
    private lazy var bottomNameSeparator = MainFactory.separator()
    
    private lazy var topPasswordSeparator = MainFactory.separator()
    
    private lazy var bottomPasswordSeparator = MainFactory.separator()
    
    private lazy var nameTextField = MainFactory.textField()
    
    private lazy var oldPasswordTextField = MainFactory.changeLabel(text: "••••••••••")
        
    private lazy var nameEditButton = MainFactory.separatedButton(text: NSLocalizedString("change", comment: ""))

    private lazy var passwordEditButton = MainFactory.separatedButton(text: NSLocalizedString("change", comment: ""))
    
    private lazy var avatarEditButton = MainFactory.separatedButton(text: NSLocalizedString("select", comment: ""))
        
    private lazy var topAvatarSeparator = MainFactory.separator()
    
    private lazy var bottomAvatarSeparator = MainFactory.separator()
    
    private lazy var saveIndicatorImage = MainFactory.hidenImageView(name: "savedChanges")
    
    private lazy var layoutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        nameTextField.text = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.tintColor = .textColor
        
        view.addSubview(editLabel)
        NSLayoutConstraint.activate([editLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), editLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), editLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([nameTextField.topAnchor.constraint(equalTo: editLabel.bottomAnchor, constant: 52), nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(nameSeparator)
        NSLayoutConstraint.activate([nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor), nameSeparator.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor), nameSeparator.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor), nameSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120), activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)])
        
        view.addSubview(oldPasswordTextField)
        NSLayoutConstraint.activate([oldPasswordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40), oldPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), oldPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), oldPasswordTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(avatarTextLabel)
        NSLayoutConstraint.activate([
            avatarTextLabel.topAnchor.constraint(equalTo: oldPasswordTextField.bottomAnchor, constant: 40),
            avatarTextLabel.leadingAnchor.constraint(equalTo: oldPasswordTextField.leadingAnchor),
            avatarTextLabel.trailingAnchor.constraint(equalTo: oldPasswordTextField.trailingAnchor),
            avatarTextLabel.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(avatarLabel)
        NSLayoutConstraint.activate([avatarLabel.bottomAnchor.constraint(equalTo: avatarTextLabel.topAnchor), avatarLabel.leadingAnchor.constraint(equalTo: avatarTextLabel.leadingAnchor), avatarLabel.heightAnchor.constraint(equalToConstant: 15)])
        
        view.addSubview(avatarEditButton)
        avatarEditButton.addTarget(self, action: #selector(changeAvatarButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([avatarEditButton.centerYAnchor.constraint(equalTo: avatarTextLabel.centerYAnchor), avatarEditButton.heightAnchor.constraint(equalToConstant: 25), avatarEditButton.widthAnchor.constraint(equalToConstant: 78), avatarEditButton.trailingAnchor.constraint(equalTo: avatarTextLabel.trailingAnchor)])
        
        view.addSubview(topAvatarSeparator)
        NSLayoutConstraint.activate(
            [topAvatarSeparator.bottomAnchor.constraint(equalTo: avatarEditButton.topAnchor),
             topAvatarSeparator.leadingAnchor.constraint(equalTo: avatarEditButton.leadingAnchor),
             topAvatarSeparator.trailingAnchor.constraint(equalTo: avatarEditButton.trailingAnchor),
             topAvatarSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(bottomAvatarSeparator)
        NSLayoutConstraint.activate(
            [bottomAvatarSeparator.topAnchor.constraint(equalTo: avatarEditButton.bottomAnchor),
             bottomAvatarSeparator.leadingAnchor.constraint(equalTo: avatarEditButton.leadingAnchor),
             bottomAvatarSeparator.trailingAnchor.constraint(equalTo: avatarEditButton.trailingAnchor),
             bottomAvatarSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(oldPasswordSeparator)
        NSLayoutConstraint.activate([oldPasswordSeparator.topAnchor.constraint(equalTo: oldPasswordTextField.bottomAnchor), oldPasswordSeparator.leadingAnchor.constraint(equalTo: oldPasswordTextField.leadingAnchor), oldPasswordSeparator.trailingAnchor.constraint(equalTo: oldPasswordTextField.trailingAnchor), oldPasswordSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(avatarSeparator)
        NSLayoutConstraint.activate([avatarSeparator.topAnchor.constraint(equalTo: avatarTextLabel.bottomAnchor), avatarSeparator.leadingAnchor.constraint(equalTo: avatarTextLabel.leadingAnchor), avatarSeparator.trailingAnchor.constraint(equalTo: avatarTextLabel.trailingAnchor), avatarSeparator.heightAnchor.constraint(equalToConstant: 1)])
                
        view.addSubview(nameEditButton)
        nameEditButton.addTarget(self, action: #selector(nameEditButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([nameEditButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor), nameEditButton.heightAnchor.constraint(equalToConstant: 25), nameEditButton.widthAnchor.constraint(equalToConstant: 78), nameEditButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor)])
        
        view.addSubview(topNameSeparator)
        NSLayoutConstraint.activate([topNameSeparator.bottomAnchor.constraint(equalTo: nameEditButton.topAnchor), topNameSeparator.leadingAnchor.constraint(equalTo: nameEditButton.leadingAnchor), topNameSeparator.trailingAnchor.constraint(equalTo: nameEditButton.trailingAnchor), topNameSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(bottomNameSeparator)
        NSLayoutConstraint.activate([bottomNameSeparator.topAnchor.constraint(equalTo: nameEditButton.bottomAnchor), bottomNameSeparator.leadingAnchor.constraint(equalTo: nameEditButton.leadingAnchor), bottomNameSeparator.trailingAnchor.constraint(equalTo: nameEditButton.trailingAnchor), bottomNameSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(passwordEditButton)
        passwordEditButton.addTarget(self, action: #selector(passwordEditButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([passwordEditButton.centerYAnchor.constraint(equalTo: oldPasswordTextField.centerYAnchor), passwordEditButton.heightAnchor.constraint(equalToConstant: 25), passwordEditButton.widthAnchor.constraint(equalToConstant: 78), passwordEditButton.trailingAnchor.constraint(equalTo: oldPasswordTextField.trailingAnchor)])
        
        view.addSubview(topPasswordSeparator)
        NSLayoutConstraint.activate([topPasswordSeparator.bottomAnchor.constraint(equalTo: passwordEditButton.topAnchor), topPasswordSeparator.leadingAnchor.constraint(equalTo: passwordEditButton.leadingAnchor), topPasswordSeparator.trailingAnchor.constraint(equalTo: passwordEditButton.trailingAnchor), topPasswordSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(bottomPasswordSeparator)
        NSLayoutConstraint.activate([bottomPasswordSeparator.topAnchor.constraint(equalTo: passwordEditButton.bottomAnchor), bottomPasswordSeparator.leadingAnchor.constraint(equalTo: passwordEditButton.leadingAnchor), bottomPasswordSeparator.trailingAnchor.constraint(equalTo: passwordEditButton.trailingAnchor), bottomPasswordSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor), nameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor), nameLabel.heightAnchor.constraint(equalToConstant: 15)])
        
        view.addSubview(passwordLabel)
        NSLayoutConstraint.activate([passwordLabel.bottomAnchor.constraint(equalTo: oldPasswordTextField.topAnchor), passwordLabel.leadingAnchor.constraint(equalTo: oldPasswordTextField.leadingAnchor), passwordLabel.heightAnchor.constraint(equalToConstant: 15)])
        
        view.addSubview(layoutView)
        NSLayoutConstraint.activate([
            layoutView.topAnchor.constraint(equalTo: avatarSeparator.bottomAnchor),
            layoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            layoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layoutView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(saveIndicatorImage)
        let topInset: CGFloat = UIScreen.main.bounds.height <= 736 ? 20 : 71
        NSLayoutConstraint.activate([
            saveIndicatorImage.centerXAnchor.constraint(equalTo: layoutView.centerXAnchor),
            saveIndicatorImage.centerYAnchor.constraint(equalTo: layoutView.centerYAnchor)
            //saveIndicatorImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 73),
            //saveIndicatorImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -73)
        ])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func animateImage() {
        UIView.animate(withDuration: 1, animations : {
            self.saveIndicatorImage.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 2, animations : {
                self.saveIndicatorImage.alpha = 0
            })
        }
    }
    
    private func isPasswordStrongEnough(password: String) -> Bool {
        let passRegEx = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    private func errorAlert(tittle:String, message: String){
        let allert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "OK", style: .default))
        present(allert, animated: true)
    }
        
    @objc
    private func nameEditButtonTapped() {
        guard let newName = nameTextField.text, !newName.isEmpty else{
            errorAlert(tittle: "Ошибка", message: "Новый логин не может быть пустым")
            return
        }
        dismissKeyboard()
        let nameData = NewUsername(newUsername: newName)
        Task {
            do{
                try await service.changeUsername(data: nameData)
                await MainActor.run {
                    animateImage()
                }
            }  catch PasswordError.wrongBody {
                print("Wrong body")
            } catch {
                await MainActor.run(body: {
                    errorAlert(tittle: "Ошибка", message: "Что-то пошло не так")
                    return
                    })
            }
        }
        
    }
    
    @objc
    private func passwordEditButtonTapped() {
        /*guard let oldPassword = oldPasswordTextField.text, let newPassword = newPasswordTextField.text, !oldPassword.isEmpty, !newPassword.isEmpty else{
            errorAlert(tittle: "Ошибка", message: "Старый и новый пароли не должны быть пустыми")
            return
        }
        
        if !isPasswordStrongEnough(password: newPassword){
            errorAlert(tittle: "Новый пароль недостаточно сложный", message: "Пароль должен содежать цифру, заглавную букву и содержать как мининмум 6 символов")
            return
        }
        
        dismissKeyboard()
        let passwordData = PasswordData(oldPassword: oldPassword, newPassword: newPassword)
        Task {
            do{
                try await service.changePassport(data: passwordData)
                await MainActor.run {
                    animateImage()
                }
            }  catch PasswordError.wrongBody {
                print("Wrong body")
            } catch PasswordError.wrongOldPassword {
                errorAlert(tittle: "Ошибка", message: "Неверный старый пароль")
                return
            } catch {
                await MainActor.run(body: {
                    errorAlert(tittle: "Ошибка", message: "Что-то пошло не так")
                    return
                    })
            }
        }*/
        navigationController?.pushViewController(ChangePasswordViewController(wasForgotten: false), animated: true)
    }
    
    @objc
    private func changeAvatarButtonTapped() {
        let viewController = ChooseShapeViewController()
        viewController.selectShapeHandler = {shapeIndex, gradientIndex in
            self.navigationController?.popViewController(animated: true)
            self.animateImage()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
