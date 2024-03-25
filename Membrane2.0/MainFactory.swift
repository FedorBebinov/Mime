//
//  MainFactory.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 06.02.2024.
//

import UIKit

final class MainFactory{
    
    // MARK: - Buttons
    static func mainButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.backgroundColor = .buttonColor
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 22)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedString, for: .normal)
        button.layer.borderColor = UIColor.borderColor.cgColor
        button.layer.borderWidth = 1.5
        button.setTitleColor(.textColor, for: .normal)
        return button
    }
    
    static func separatedButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 15)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        return button
    }
    
    static func imageButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
        
    static func circleButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 27.5
        button.setImage(UIImage(named: imageName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.textColor, for: .normal)
        button.backgroundColor = .buttonColor
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.borderColor.cgColor
        return button
    }
    
    static func systemButton(systemName: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 27.5
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .textColor
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.borderColor.cgColor
        return button
    }
    
    static func menuButton(text: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 30, bottom: 14, trailing: 30)
        config.baseForegroundColor = .textColor
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 25
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 18)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .buttonColor
        button.isHidden = true
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.borderColor.cgColor
        return button
    }
    
    static func editButton() -> UIButton {
        let button: UIButton = UIButton()
        button.backgroundColor = .backgroundColor
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 15)!]
        let attributedString = NSAttributedString(string: "Изменить", attributes: attributes)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        return button
    }
    
    // MARK: - Text Fields
    static func textField() -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 25)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        return nameTextField
    }
    
    static func passwordTextField(placeholder: String) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 25)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.isSecureTextEntry = true
        nameTextField.placeholder = placeholder
        return nameTextField
    }
    
    static func textFieldWithPlaceholder(placeholder: String) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 40)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.placeholder = placeholder
        return nameTextField
    }
    
    static func textFieldWithSmallPlaceholder(placeholder: String) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 25)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.placeholder = placeholder
        return nameTextField
    }
    
    // MARK: - Labels
    static func topLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }
    
    static func gestureTextLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6
        label.textColor = .textColor
        return label
    }
    
    static func changeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .changeLabelColor
        return label
    }
    
    static func miniLabel(text: String) ->UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .separatorColor
        return label
    }
    
    static func hidenLabel(text: String) ->UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        label.alpha = 0
        return label
    }
    
    // MARK: - Views
    static func separator() -> UIView{
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separatorColor
        return separator
    }
    
    static func paleSeparator() -> UIView{
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .paleSeparatorColor
        return separator
    }
    
    static func avatarView() -> AvatarView {
        let avatar = AvatarView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }
    
    static func imageView(name: String) -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: name)
        return image
    }
    
    static func doorImageView() ->UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "inactiveDoor")
        image.contentMode = .scaleAspectFit
        return image
    }
    
    static func hidenImageView(name: String) -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: name)
        image.alpha = 0
        return image
    }
    
    static func loadingView() -> UIView{
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.alpha = 0.5
        view.isHidden = true
        return view
    }
}
