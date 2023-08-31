//
//  ViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 21.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.text = "Как тебя зовут"
        nameLabel.font = .fontWithSize(size: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .textColor
        return nameLabel
    }()
    
    private lazy var separator: UIView = {
        var separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray
        return separator
    }()
    
    private lazy var nameTextField: UITextField = {
        var nameTextField = UITextField()
        nameTextField.font = .fontWithSize(size: 40)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .textColor
        nameTextField.tintColor = nameTextField.textColor
        return nameTextField
    }()
    
    private lazy var readyButton: UIButton = {
        var readyButton = UIButton()
        readyButton.layer.cornerRadius = 40
        //readyButton.isEnabled = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.fontWithSize(size: 18)!
        ]
        let attributedString = NSAttributedString(string: "Готово", attributes: attributes)
        readyButton.setAttributedTitle(attributedString, for: .normal)
        readyButton.setTitleColor(.textColor, for: .normal)
        readyButton.backgroundColor = .buttonColor
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        return readyButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 98), nameTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(readyButton)
        NSLayoutConstraint.activate(
            [readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), readyButton.heightAnchor.constraint(equalToConstant: 80), readyButton.widthAnchor.constraint(equalToConstant: 350), readyButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 80)])
        
        view.addSubview(separator)
        NSLayoutConstraint.activate([separator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor), separator.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor), separator.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor), separator.heightAnchor.constraint(equalToConstant: 1)])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    @objc
    func readyButtonTapped(){
        navigationController?.pushViewController(MainViewController(), animated: true)
        //navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
}

