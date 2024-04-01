//
//  MainViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 22.08.2023.
//

import UIKit

class ChooseShapeViewController: UIViewController {
    
    var selectShapeHandler: ((Int, Int)->Void)?
    
    private let shapes = [AvatarImage.portal, AvatarImage.shield, AvatarImage.spinner, AvatarImage.door, AvatarImage.drum]
    
    private let service = NetworkService()
    
    private var shapeIndex = 0
    private var gradientIndex = 0
                                                                                                               
    private lazy var avatarView = MainFactory.avatarView()
    
    private lazy var rightButton = MainFactory.imageButton(imageName: "rightArrow")
    
    private lazy var leftButton = MainFactory.imageButton(imageName: "leftArrow")
    
    private lazy var pinkWhiteButton = MainFactory.imageButton(imageName: "pinkWhiteCircle")
    
    private lazy var grayWhiteButton = MainFactory.imageButton(imageName: "grayWhiteCircle")
    
    private lazy var pinkOrangeButton = MainFactory.imageButton(imageName: "pinkOrangeCircle")
    
    private lazy var yellowOrangeButton = MainFactory.imageButton(imageName: "yellowOrangeCircle")
    
    private lazy var purplePinkButton = MainFactory.imageButton(imageName: "purplePinkCircle")
    
    private lazy var doneButton = MainFactory.mainButton(text: "Готово")
    
    private lazy var chooseShapeLabel = MainFactory.topLabel(text: "Выберите свою фигуру")
    
    private lazy var colorButtonsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [pinkWhiteButton, grayWhiteButton, pinkOrangeButton, yellowOrangeButton, purplePinkButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        updateShape()
        updateGradient()
        
        view.addSubview(chooseShapeLabel)
        NSLayoutConstraint.activate([chooseShapeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), chooseShapeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), chooseShapeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)])
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25), doneButton.widthAnchor.constraint(equalToConstant: 350), doneButton.heightAnchor.constraint(equalToConstant: 80)])
        
        view.addSubview(avatarView)
        NSLayoutConstraint.activate([avatarView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50), avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        view.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([rightButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor), rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5), rightButton.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor), rightButton.heightAnchor.constraint(equalToConstant: 135)])
        
        view.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([leftButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor), leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5), leftButton.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor), leftButton.heightAnchor.constraint(equalToConstant: 135)])
        
        view.addSubview(colorButtonsStackView)
        pinkWhiteButton.addTarget(self, action: #selector(pinkWhiteButtonTapped), for: .touchUpInside)
        grayWhiteButton.addTarget(self, action: #selector(grayWhiteButtonTapped), for: .touchUpInside)
        pinkOrangeButton.addTarget(self, action: #selector(pinkOrangeButtonTapped), for: .touchUpInside)
        yellowOrangeButton.addTarget(self, action: #selector(yellowOrangeButtonTapped), for: .touchUpInside)
        purplePinkButton.addTarget(self, action: #selector(purplePinkButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([colorButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor), colorButtonsStackView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    private func updateShape(){
        let shape = shapes[shapeIndex]
        avatarView.avatarImageView.image = shape.image
        avatarView.maskLayer.contents = avatarView.avatarImageView.image?.cgImage
    }
    
    private func updateGradient(){
        let gradient = gradients[gradientIndex]
        avatarView.apply(gradient: gradient)
    }
    
    @objc
    private func doneButtonTapped(){
        let avatar: AvatarData = AvatarData(type: shapes[shapeIndex].rawValue, color: gradients[gradientIndex].name)
        Task {
            do {
                try await service.saveAvatar(data: avatar)
                await MainActor.run {
                    if let selectShapeHandler {
                        selectShapeHandler(shapeIndex, gradientIndex)
                    } else{
                        navigationController?.pushViewController(MenuViewController(isOnboarding: true), animated: true)
                    }
                }
            } catch{
                print(error)
            }
        }
        
    }
    
    @objc
    private func rightButtonTapped(){
        shapeIndex = (shapeIndex + 1) % 5
        updateShape()
    }
    
    @objc
    private func leftButtonTapped(){
        shapeIndex = shapeIndex - 1
        if shapeIndex < 0 {
            shapeIndex = shapes.count - 1
        }
        updateShape()
    }
    
    @objc
    private func pinkWhiteButtonTapped(){
        gradientIndex = 0
        updateGradient()
    }
    
    @objc
    private func grayWhiteButtonTapped(){
        gradientIndex = 1
        updateGradient()
    }
    
    @objc
    private func pinkOrangeButtonTapped(){
        gradientIndex = 2
        updateGradient()
    }
    
    @objc
    private func yellowOrangeButtonTapped(){
        gradientIndex = 3
        updateGradient()
    }
    
    @objc
    private func purplePinkButtonTapped(){
        gradientIndex = 4
        updateGradient()
    }
}
