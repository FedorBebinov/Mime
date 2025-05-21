//
//  AccountViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 30.09.2024.
//

import UIKit

class AccountViewController: UIViewController {
    
    private lazy var accountLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("account", comment: ""))
    
    private lazy var actionsLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("actions", comment: ""))
    
    private lazy var deleteAccountButton = MainFactory.deleteButton(text: NSLocalizedString("deleteAccount", comment: ""))
    
    private lazy var deleteAccountSeparator = MainFactory.paleSeparator()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(accountLabel)
        view.addSubview(actionsLabel)
        view.addSubview(deleteAccountButton)
        view.addSubview(deleteAccountSeparator)
        
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            accountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            accountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            accountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            actionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            actionsLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 52),
            
            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            deleteAccountButton.topAnchor.constraint(equalTo: actionsLabel.bottomAnchor, constant: 18),
            
            deleteAccountSeparator.leadingAnchor.constraint(equalTo: deleteAccountButton.leadingAnchor),
            deleteAccountSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deleteAccountSeparator.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 18),
            deleteAccountSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc
    func deleteAccountButtonTapped(){
        //precautionaryAlert.showAlert(from: self)
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.delegate = self
        self.present(alert, animated: false)
    }
}

extension AccountViewController: PredeleteDelegate{
    func deleteButtonTapped() {
        navigationController?.pushViewController(DeleteAccountViewController(), animated: true)
    }
}
