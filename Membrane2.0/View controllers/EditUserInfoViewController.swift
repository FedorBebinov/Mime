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
    
    private lazy var editLabel = MainFactory.topLabel(text: "Редактирование профиля")
    
    private lazy var nameLabel = MainFactory.miniLabel(text: "Логин")
    
    private lazy var passwordLabel = MainFactory.miniLabel(text: "Пароль")
    
    private lazy var avatarLabel = MainFactory.miniLabel(text: "Аватар")
    
    private lazy var avatarTextLabel = MainFactory.changeLabel(text: "Выбрать другой")
    
    private lazy var nameSeparator = MainFactory.paleSeparator()
    
    private lazy var oldPasswordSeparator = MainFactory.paleSeparator()
    
    private lazy var newPasswordSeparator = MainFactory.paleSeparator()
    
    private lazy var avatarSeparator = MainFactory.paleSeparator()
    
    private lazy var topNameSeparator = MainFactory.separator()
    
    private lazy var bottomNameSeparator = MainFactory.separator()
    
    private lazy var topPasswordSeparator = MainFactory.separator()
    
    private lazy var bottomPasswordSeparator = MainFactory.separator()
    
    private lazy var nameTextField = MainFactory.textField()
    
    private lazy var oldPasswordTextField = MainFactory.passwordTextField(placeholder: "Старый пароль")
    
    private lazy var newPasswordTextField = MainFactory.passwordTextField(placeholder: "Новый пароль")
    
    private lazy var nameEditButton = MainFactory.editButton()
    
    private lazy var passwordEditButton = MainFactory.editButton()
    
    private lazy var avatarEditButton = MainFactory.separatedButton(text: "Перейти")
    
    private lazy var changeAvatarButton = MainFactory.separatedButton(text: "Сменить фигуру")
    
    private lazy var topAvatarSeparator = MainFactory.separator()
    
    private lazy var bottomAvatarSeparator = MainFactory.separator()
    
    private lazy var saveIndicatorImage = MainFactory.hidenImageView(name: "savedChanges")
    
    private lazy var passwordButton = MainFactory.imageButton(imageName: "showPassword")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        hideKeyboardWhenTappedAround()
        activityIndicatorView.startAnimating()
        Task {
            do {
                let username = try await service.getUsername()
                await MainActor.run {
                    activityIndicatorView.stopAnimating()
                    nameTextField.text = username
                }
                
            } catch{
                print(error)
            }
        }
        
        navigationController?.navigationBar.tintColor = .white
        
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
        
        view.addSubview(newPasswordTextField)
        NSLayoutConstraint.activate([newPasswordTextField.topAnchor.constraint(equalTo: oldPasswordTextField.bottomAnchor, constant: 3), newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), newPasswordTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(avatarTextLabel)
        NSLayoutConstraint.activate([
            avatarTextLabel.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 40),
            avatarTextLabel.leadingAnchor.constraint(equalTo: newPasswordTextField.leadingAnchor),
            avatarTextLabel.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor),
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
        
        view.addSubview(newPasswordSeparator)
        NSLayoutConstraint.activate([newPasswordSeparator.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor), newPasswordSeparator.leadingAnchor.constraint(equalTo: newPasswordTextField.leadingAnchor), newPasswordSeparator.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor), newPasswordSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
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
        NSLayoutConstraint.activate([passwordEditButton.centerYAnchor.constraint(equalTo: newPasswordTextField.centerYAnchor), passwordEditButton.heightAnchor.constraint(equalToConstant: 25), passwordEditButton.widthAnchor.constraint(equalToConstant: 78), passwordEditButton.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor)])
        
        view.addSubview(topPasswordSeparator)
        NSLayoutConstraint.activate([topPasswordSeparator.bottomAnchor.constraint(equalTo: passwordEditButton.topAnchor), topPasswordSeparator.leadingAnchor.constraint(equalTo: passwordEditButton.leadingAnchor), topPasswordSeparator.trailingAnchor.constraint(equalTo: passwordEditButton.trailingAnchor), topPasswordSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(bottomPasswordSeparator)
        NSLayoutConstraint.activate([bottomPasswordSeparator.topAnchor.constraint(equalTo: passwordEditButton.bottomAnchor), bottomPasswordSeparator.leadingAnchor.constraint(equalTo: passwordEditButton.leadingAnchor), bottomPasswordSeparator.trailingAnchor.constraint(equalTo: passwordEditButton.trailingAnchor), bottomPasswordSeparator.heightAnchor.constraint(equalToConstant: 1)])
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor), nameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor), nameLabel.heightAnchor.constraint(equalToConstant: 15)])
        
        view.addSubview(passwordLabel)
        NSLayoutConstraint.activate([passwordLabel.bottomAnchor.constraint(equalTo: oldPasswordTextField.topAnchor), passwordLabel.leadingAnchor.constraint(equalTo: oldPasswordTextField.leadingAnchor), passwordLabel.heightAnchor.constraint(equalToConstant: 15)])
        
        view.addSubview(saveIndicatorImage)
        NSLayoutConstraint.activate([saveIndicatorImage.topAnchor.constraint(equalTo: avatarTextLabel.bottomAnchor, constant: 40), saveIndicatorImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 73), saveIndicatorImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -73)])
        
        view.addSubview(passwordButton)
        passwordButton.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([passwordButton.trailingAnchor.constraint(equalTo: oldPasswordTextField.trailingAnchor), passwordButton.centerYAnchor.constraint(equalTo: oldPasswordTextField.centerYAnchor)])

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
    func nameEditButtonTapped() {
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
    func passwordButtonTapped() {
        isPasswordHidden.toggle()
        oldPasswordTextField.isSecureTextEntry.toggle()
        newPasswordTextField.isSecureTextEntry.toggle()
        if isPasswordHidden{
            passwordButton.setImage(UIImage(named: "showPassword"), for: .normal)
        } else {
            passwordButton.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
    }
    
    @objc
    func passwordEditButtonTapped() {
        guard let oldPassword = oldPasswordTextField.text, let newPassword = newPasswordTextField.text, !oldPassword.isEmpty, !newPassword.isEmpty else{
            errorAlert(tittle: "Ошибка", message: "Старый и новый пароли не должны быть пустыми")
            return
        }
        
        if !isPasswordStrongEnough(password: newPassword){
            errorAlert(tittle: "Ошибка", message: "Новый пароль недостаточно сложный")
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
        }
    }
    
    @objc
    func changeAvatarButtonTapped() {
        let viewController = ChooseShapeViewController()
        viewController.selectShapeHandler = {shapeIndex, gradientIndex in
            self.navigationController?.popViewController(animated: true)
            self.animateImage()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
