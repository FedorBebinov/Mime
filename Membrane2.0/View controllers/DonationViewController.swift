//
//  DonationViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 20.04.2024.
//

import UIKit

class DonationViewController: UIViewController {
    
    private lazy var supportLabel = MainFactory.topLabel(text: "Поддрежать проект")
    
    private lazy var textPic = MainFactory.imageView(name: "supportText")
    
    private lazy var teamPic = MainFactory.imageView(name: "authorsDonate")
    
    private lazy var donateButton = MainFactory.mainButton(text: "Поддержать авторов")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(supportLabel)
        view.addSubview(textPic)
        view.addSubview(donateButton)
        view.addSubview(teamPic)
        
        NSLayoutConstraint.activate([
            supportLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            supportLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            supportLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            textPic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textPic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textPic.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 32),
            
            teamPic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            teamPic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            teamPic.topAnchor.constraint(equalTo: textPic.bottomAnchor, constant: 45),
            
            donateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            donateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            donateButton.heightAnchor.constraint(equalToConstant: 80),
            donateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -99)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
