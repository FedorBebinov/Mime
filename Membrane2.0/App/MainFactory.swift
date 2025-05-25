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
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 18)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedString, for: .normal)
        button.layer.borderColor = UIColor.borderColor.cgColor
        button.layer.borderWidth = 1.5
        button.setTitleColor(.buttonTextColor, for: .normal)
        return button
    }
    
    static func disabledMainButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.cornerRadius = 40
        // Создание атрибутированного текста для состояний
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.fontWithSize(size: 18)!,
            .foregroundColor: UIColor.buttonTextColor]
        let disabledAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.fontWithSize(size: 18)!,
            .foregroundColor: UIColor.gray]
        let attributedStringNormal = NSAttributedString(string: text, attributes: normalAttributes)
        let attributedStringDisabled = NSAttributedString(string: text, attributes: disabledAttributes)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.borderColor.cgColor
        button.layer.borderWidth = 1.5
        button.isEnabled = false
        button.setAttributedTitle(attributedStringDisabled, for: .disabled)
        button.setAttributedTitle(attributedStringNormal, for: .normal)
        return button
    }
    
    static func separatedButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 12)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        return button
    }
    
    static func separatedDeleteButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 12)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.destructiveRed, for: .normal)
        return button
    }
    
    static func separatedRoomButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 12)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.roomIdButtonTextColor, for: .normal)
        return button
    }
    
    static func separatedBigButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let white:UIColor = .textColor
        let gray: UIColor = .separatorColor
        let attributesNormal: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 14)!, .foregroundColor: white]
        let attributesDisabled: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 14)!, .foregroundColor: gray]
        let normalString = NSAttributedString(string: text, attributes: attributesNormal)
        let diasabledString = NSAttributedString(string: text, attributes: attributesDisabled)
        button.setAttributedTitle(normalString, for: .normal)
        button.setAttributedTitle(diasabledString, for: .disabled)
        return button
    }
    
    static func deleteButton(text: String) -> UIButton {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 18)!]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.destructiveRed, for: .normal)
        return button
    }
    
    static func imageButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
    
    static func imageButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    static func imageButtonTemplate(imageName: String) -> UIButton {
        let button = CustomButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        button.touchAreaInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
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
        config.baseForegroundColor = .buttonTextColor
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
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 12)!]
        let attributedString = NSAttributedString(string: "Изменить", attributes: attributes)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        return button
    }
    
    static func switchButton() -> UISwitch {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }
    
    // MARK: - Text Fields
    static func textField() -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 18)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.autocorrectionType = .no
        return nameTextField
    }
    
    static func passwordTextField(placeholder: String?) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 18)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.isSecureTextEntry = true
        if let placeholder{
            nameTextField.placeholder = placeholder
        }
        nameTextField.autocorrectionType = .no
        return nameTextField
    }
    
    static func textFieldWithPlaceholder(placeholder: String) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 18)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.placeholder = placeholder
        nameTextField.autocorrectionType = .no
        return nameTextField
    }
    
    static func textFieldLogin(placeholder: String) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 18)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.placeholder = placeholder
        nameTextField.autocorrectionType = .no
        return nameTextField
    }
    
    static func textFieldWithSmallPlaceholder(placeholder: String) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 18)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        nameTextField.placeholder = placeholder
        nameTextField.autocorrectionType = .no
        return nameTextField
    }
    
    // MARK: - Labels
    static func topLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }
    
    static func textLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 12)
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

    static func gestureRoomTextLabel(text: String) -> UILabel {
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
        label.font = .fontWithSize(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .changeLabelColor
        return label
    }
    
    static func miniLabel(text: String) ->UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .separatorColor
        return label
    }
    
    static func hidenLabel(text: String) ->UILabel {
        let label = UILabel()
        label.text = text
        label.font = .fontWithSize(size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
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
    
    static func imageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
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
        view.backgroundColor = .shadowColor
        //view.alpha = 0.5
        view.isHidden = true
        return view
    }
}
