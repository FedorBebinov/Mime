//
//  CreateRoomViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 12.02.2024.
//

import UIKit

class EnterRoomViewController: UIViewController {
    
    private lazy var typeNumberLabel = MainFactory.topLabel(text: NSLocalizedString("enterRoomNumber", comment: ""))
    
    private lazy var roomNumberTextField = MainFactory.textFieldWithPlaceholder(placeholder: NSLocalizedString("roomNumber", comment: ""))
    
    private lazy var separator = MainFactory.separator()
    
    private lazy var doneButton = MainFactory.mainButton(text: NSLocalizedString("doneGotov", comment: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.tintColor = .textColor
        
        view.addSubview(typeNumberLabel)
        view.addSubview(roomNumberTextField)
        view.addSubview(separator)
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
                
        NSLayoutConstraint.activate([typeNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35), typeNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), typeNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), roomNumberTextField.topAnchor.constraint(equalTo: typeNumberLabel.bottomAnchor, constant: 100), roomNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), roomNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), roomNumberTextField.heightAnchor.constraint(equalToConstant: 50), separator.topAnchor.constraint(equalTo: roomNumberTextField.bottomAnchor), separator.heightAnchor.constraint(equalToConstant: 1), separator.leadingAnchor.constraint(equalTo: roomNumberTextField.leadingAnchor), separator.trailingAnchor.constraint(equalTo: roomNumberTextField.trailingAnchor), doneButton.topAnchor.constraint(equalTo: roomNumberTextField.bottomAnchor, constant: 80), doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), doneButton.heightAnchor.constraint(equalToConstant: 80)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        roomNumberTextField.becomeFirstResponder()
    }
    
    @objc
    private func doneButtonTapped(){
        guard let roomNumber = roomNumberTextField.text else{
            let allert = UIAlertController(title: "Ошибка", message: "Код комнаты не может быть пустым", preferredStyle: .alert)
            allert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(allert, animated: true)
            return
        }
        
        navigationController?.pushViewController(CallViewController(isEnter: true, isOnboarding: false, roomId: roomNumber), animated: true)
    }
}
