//
//  GesturesViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 26.02.2024.
//

import UIKit

class GesturesViewController: UIViewController {
    
    private let mainTextLabel = MainFactory.gestureTextLabel(text: "Взаимодействие с друзьями происходит через жесты. У каждого жеста есть своя уникальная анимация. На данный момент доступно 3 варианта взаимодействия:")
    
    private let touchImageView = MainFactory.imageView(name: "touchImage")
    
    private let zoomImageView = MainFactory.imageView(name: "zoomImage")
    
    private let longPressImageView = MainFactory.imageView(name: "longPressImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(mainTextLabel)
        view.addSubview(touchImageView)
        view.addSubview(zoomImageView)
        view.addSubview(longPressImageView)
        
        NSLayoutConstraint.activate(
            [mainTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 43), mainTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), mainTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            touchImageView.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 40), touchImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                    
            zoomImageView.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 40), zoomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                                     
            longPressImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), longPressImageView.topAnchor.constraint(equalTo: touchImageView.bottomAnchor, constant: 20)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
