//
//  AchievementsViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 23.04.2024.
//

import UIKit

class AchievementsViewController: UIViewController {
    
    private lazy var achievementsLabel = MainFactory.topLabel(text: "Достижения")
    
    private lazy var messagesLabel = MainFactory.topLabel(text: "Общительный")
    
    private lazy var messagesMiniLabel = MainFactory.miniLabel(text: "Отправьте 100 сообщений")
    
    private lazy var messageNumLabel = MainFactory.miniLabel(text: "0/100")
    
    private lazy var messagesRadioImage = MainFactory.imageView(name: "radio")
    
    private lazy var daysLabel = MainFactory.topLabel(text: "Постоялец")
    
    private lazy var daysMiniLabel = MainFactory.miniLabel(text: "Заходите в приложение 15 дней")
    
    private lazy var daysNumLabel = MainFactory.miniLabel(text: "0/15")
    
    private lazy var daysRadioImage = MainFactory.imageView(name: "radio")
    
    private lazy var callsLabel = MainFactory.topLabel(text: "Тесная связь")
    
    private lazy var callsMiniLabel = MainFactory.miniLabel(text: "Проведите с одним собеседником 5 звонков")
    
    private lazy var callsNumLabel = MainFactory.miniLabel(text: "0/5")
    
    private lazy var callsRadioImage = MainFactory.imageView(name: "radio")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(achievementsLabel)
        view.addSubview(messagesLabel)
        view.addSubview(messagesMiniLabel)
        view.addSubview(messageNumLabel)
        view.addSubview(messagesRadioImage)
        view.addSubview(daysLabel)
        view.addSubview(daysMiniLabel)
        view.addSubview(daysNumLabel)
        view.addSubview(daysRadioImage)
        view.addSubview(callsLabel)
        view.addSubview(callsMiniLabel)
        view.addSubview(callsNumLabel)
        view.addSubview(callsRadioImage)
        
        NSLayoutConstraint.activate([
            achievementsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            achievementsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            achievementsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        
            messagesLabel.topAnchor.constraint(equalTo: achievementsLabel.bottomAnchor, constant: 76),
            messagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            messagesRadioImage.centerYAnchor.constraint(equalTo: messagesLabel.centerYAnchor),
            messagesRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            messagesMiniLabel.topAnchor.constraint(equalTo: messagesLabel.bottomAnchor, constant: 10),
            messagesMiniLabel.leadingAnchor.constraint(equalTo: messagesLabel.leadingAnchor),
            
            messageNumLabel.centerYAnchor.constraint(equalTo: messagesMiniLabel.centerYAnchor),
            messageNumLabel.leadingAnchor.constraint(equalTo: messagesMiniLabel.trailingAnchor, constant: 10),
            
            daysLabel.topAnchor.constraint(equalTo: messagesLabel.bottomAnchor, constant: 50),
            daysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            daysRadioImage.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            daysRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            daysMiniLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 10),
            daysMiniLabel.leadingAnchor.constraint(equalTo: daysLabel.leadingAnchor),
            
            daysNumLabel.centerYAnchor.constraint(equalTo: daysMiniLabel.centerYAnchor),
            daysNumLabel.leadingAnchor.constraint(equalTo: daysMiniLabel.trailingAnchor, constant: 10),
            
            callsLabel.topAnchor.constraint(equalTo: daysNumLabel.bottomAnchor, constant: 50),
            callsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            callsRadioImage.centerYAnchor.constraint(equalTo: callsLabel.centerYAnchor),
            callsRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            callsMiniLabel.topAnchor.constraint(equalTo: callsLabel.bottomAnchor, constant: 10),
            callsMiniLabel.leadingAnchor.constraint(equalTo: callsLabel.leadingAnchor),
            
            callsNumLabel.centerYAnchor.constraint(equalTo: callsMiniLabel.centerYAnchor),
            callsNumLabel.leadingAnchor.constraint(equalTo: callsMiniLabel.trailingAnchor, constant: 10),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
