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
    
    private lazy var avatarsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AvatarView.self, forCellWithReuseIdentifier: "AvatarCell")
        return collectionView
    }()
    
    private lazy var rightButton = MainFactory.imageButtonTemplate(imageName: "rightArrow")
    
    private lazy var leftButton =  MainFactory.imageButtonTemplate(imageName: "leftArrow")
    
    private lazy var pinkWhiteButton = MainFactory.imageButton(imageName: "pinkWhiteCircle")
    
    private lazy var grayWhiteButton = MainFactory.imageButton(imageName: "grayWhiteCircle")
    
    private lazy var pinkOrangeButton = MainFactory.imageButton(imageName: "pinkOrangeCircle")
    
    private lazy var yellowOrangeButton = MainFactory.imageButton(imageName: "yellowOrangeCircle")
    
    private lazy var purplePinkButton = MainFactory.imageButton(imageName: "purplePinkCircle")
    
    private lazy var doneButton = MainFactory.mainButton(text: NSLocalizedString("doneGotov", comment: ""))
    
    private lazy var chooseShapeLabel = MainFactory.topLabel(text: NSLocalizedString("chooseFigure", comment: ""))
    
    private var colorButtonContainers: [UIView] = []
    
    private lazy var colorButtons: [UIButton] = [
        pinkWhiteButton,
        grayWhiteButton,
        pinkOrangeButton,
        yellowOrangeButton,
        purplePinkButton
    ]

    private lazy var colorButtonsStackView: UIStackView = {
        colorButtonContainers = colorButtons.map { button in
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: 40),   // Размер круга
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            container.widthAnchor.constraint(equalToConstant: 60).isActive = true // чуть больше, для бордера
            container.heightAnchor.constraint(equalToConstant: 60).isActive = true
            return container
        }
        let stackView = UIStackView(arrangedSubviews: colorButtonContainers)
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
        
        view.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            rightButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            //rightButton.leadingAnchor.constraint(equalTo: avatarsCollectionView.trailingAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 20),
            rightButton.heightAnchor.constraint(equalToConstant: 135)
        ])
        
        view.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            //leftButton.trailingAnchor.constraint(equalTo: avatarsCollectionView.leadingAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 20),
            leftButton.heightAnchor.constraint(equalToConstant: 135)
        ])
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            doneButton.widthAnchor.constraint(equalToConstant: 350),
            doneButton.heightAnchor.constraint(equalToConstant: 80)])
        
        view.addSubview(colorButtonsStackView)
        pinkWhiteButton.addTarget(self, action: #selector(pinkWhiteButtonTapped), for: .touchUpInside)
        grayWhiteButton.addTarget(self, action: #selector(grayWhiteButtonTapped), for: .touchUpInside)
        pinkOrangeButton.addTarget(self, action: #selector(pinkOrangeButtonTapped), for: .touchUpInside)
        yellowOrangeButton.addTarget(self, action: #selector(yellowOrangeButtonTapped), for: .touchUpInside)
        purplePinkButton.addTarget(self, action: #selector(purplePinkButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            colorButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorButtonsStackView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20)])
        
        view.addSubview(chooseShapeLabel)
        NSLayoutConstraint.activate([
            chooseShapeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            chooseShapeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            chooseShapeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)])
        
        view.addSubview(avatarsCollectionView)
        NSLayoutConstraint.activate([
            avatarsCollectionView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 25),
            avatarsCollectionView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -25),
            avatarsCollectionView.topAnchor.constraint(equalTo: chooseShapeLabel.bottomAnchor, constant: 67),
            avatarsCollectionView.bottomAnchor.constraint(equalTo: colorButtonsStackView.topAnchor, constant: -30)])
        
        
        updateColorSelection()
        /*view.addSubview(avatarView)
         NSLayoutConstraint.activate([avatarView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50), avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: shapeIndex, section: 0)
        avatarsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        shapeIndex = page
    }
    
    private func updateShape(){
        avatarsCollectionView.reloadData()
    }
    
    private func updateGradient(){
        avatarsCollectionView.reloadData()
    }
    
    private func updateColorSelection(animated: Bool = true) {
        for (index, container) in colorButtonContainers.enumerated() {
            if index == gradientIndex {
                container.layer.borderColor = UIColor.buttonSelectColor.cgColor
                container.layer.borderWidth = 10
                container.layer.cornerRadius = 30
                container.layer.masksToBounds = false
                container.layer.shadowColor = UIColor.shadowColor.cgColor
                container.layer.shadowOpacity = 0.22
                container.layer.shadowOffset = CGSize(width: 0, height: 2)
                container.layer.shadowRadius = 4
            } else {
                container.layer.borderWidth = 0
                container.layer.borderColor = nil
                container.layer.shadowOpacity = 0
            }
        }
    }
    
    @objc
    private func doneButtonTapped(){
        let avatar: AvatarData = AvatarData(type: shapes[shapeIndex].rawValue, color: gradients[gradientIndex].name, hasBorder: false)
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
        shapeIndex = (shapeIndex + 1) % shapes.count
        updateShape()
        avatarsCollectionView.scrollToItem(at: IndexPath(item: shapeIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc
    private func leftButtonTapped(){
        shapeIndex = (shapeIndex - 1 + shapes.count) % shapes.count
        updateShape()
        avatarsCollectionView.scrollToItem(at: IndexPath(item: shapeIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc
    private func pinkWhiteButtonTapped(){
        gradientIndex = 0
        updateGradient()
        updateColorSelection()
    }
    
    @objc
    private func grayWhiteButtonTapped(){
        gradientIndex = 1
        updateGradient()
        updateColorSelection()
    }
    
    @objc
    private func pinkOrangeButtonTapped(){
        gradientIndex = 2
        updateGradient()
        updateColorSelection()
    }
    
    @objc
    private func yellowOrangeButtonTapped(){
        gradientIndex = 3
        updateGradient()
        updateColorSelection()
    }
    
    @objc
    private func purplePinkButtonTapped(){
        gradientIndex = 4
        updateGradient()
        updateColorSelection()
    }
}

extension ChooseShapeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarView
        let gradient = gradients[gradientIndex]
        let shapeImage = shapes[indexPath.item].image
        cell.avatarImageView.image = shapeImage
        cell.apply(gradient: gradient)
        cell.applyMask(image: shapeImage)
        cell.avatarImageView.backgroundColor = .backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
