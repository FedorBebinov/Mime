//
//  GesturesTraining.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 06.02.2024.
//

import UIKit
import SwiftyGif
import AVFoundation

class CallViewController: UIViewController, MessageServiceDelegate {
    
    private var roomId: String?
    
    private var zoomGif: UIImageView?
    
    private var didComplete = false
    
    private var audioPlayer = AVAudioPlayer()
    
    private lazy var enterLabel = MainFactory.hidenLabel(text: "Собеседник подключился")
    
    private var isEnter: Bool
    
    private var isOnboarding: Bool
    
    private lazy var onboardingLabel = MainFactory.gestureTextLabel(text: "А теперь попробуем потренировать жесты. Нажмите на экран для распознания жеста\"Касание\"")
    
    private var tapCounter = 0
    
    private lazy var backMenuButton = MainFactory.mainButton(text: "Вернуться в меню")
    
    private lazy var roomIdButton = MainFactory.separatedButton(text: "Номер комнаты:")
    
    private lazy var shareButton = MainFactory.imageButton(imageName: "shareButton")
    
    private lazy var topSeparator = MainFactory.separator()
    
    private lazy var bottomSeparator = MainFactory.separator()
    
    private lazy var copyLabel = MainFactory.hidenLabel(text: "Код скопирован!")
    
    private lazy var quitDoorButton = MainFactory.imageButton(imageName: "quitDoor")
    
    private lazy var doorImage: UIImageView = MainFactory.doorImageView()
    
    private lazy var gesturesButton = MainFactory.imageButton(imageName: "gesturesButton")
    
    private lazy var topElementsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [quitDoorButton, doorImage, gesturesButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 100
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var isUserInRoom = false {
        didSet{
            if isUserInRoom {
                doorImage.image = UIImage(named: "activeDoor")
            } else{
                doorImage.image = UIImage(named: "inactiveDoor")
            }
        }
    }
    
    private lazy var messageService: MessageService = {
        var messageService = MessageService()
        messageService.delegate = self
        return messageService
    }()
    
    init(isEnter: Bool, isOnboarding: Bool, roomId: String?){
        self.isEnter = isEnter
        self.isOnboarding = isOnboarding
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
                
        if let roomId = self.roomId {
            messageService.connectToRoomId(roomId: roomId)
        } else {
            messageService.connectToRoomId(roomId: "create")
        }
        
        view.addSubview(topElementsStackView)
        gesturesButton.addTarget(self, action: #selector(gesturesButtonTapped), for: .touchUpInside)
        quitDoorButton.addTarget(self, action: #selector(quitDoorButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([topElementsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), topElementsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35), topElementsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)])
        
        view.addSubview(roomIdButton)
        roomIdButton.isHidden = isEnter
        roomIdButton.addTarget(self, action: #selector(roomIdButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([roomIdButton.heightAnchor.constraint(equalToConstant: 25), roomIdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), roomIdButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)])
        
        view.addSubview(copyLabel)
        NSLayoutConstraint.activate([copyLabel.bottomAnchor.constraint(equalTo: roomIdButton.topAnchor, constant: -20), copyLabel.centerXAnchor.constraint(equalTo: roomIdButton.centerXAnchor)])
        
        view.addSubview(enterLabel)
        NSLayoutConstraint.activate([enterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), enterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        view.addSubview(topSeparator)
        view.addSubview(bottomSeparator)
        topSeparator.isHidden = isEnter
        bottomSeparator.isHidden = isEnter
        NSLayoutConstraint.activate([topSeparator.heightAnchor.constraint(equalToConstant: 1), topSeparator.leadingAnchor.constraint(equalTo: roomIdButton.leadingAnchor), topSeparator.trailingAnchor.constraint(equalTo: roomIdButton.trailingAnchor), topSeparator.bottomAnchor.constraint(equalTo: roomIdButton.topAnchor), bottomSeparator.heightAnchor.constraint(equalToConstant: 1), bottomSeparator.trailingAnchor.constraint(equalTo: roomIdButton.trailingAnchor), bottomSeparator.leadingAnchor.constraint(equalTo: roomIdButton.leadingAnchor), bottomSeparator.topAnchor.constraint(equalTo: roomIdButton.bottomAnchor)])
        
        view.addSubview(shareButton)
        shareButton.isHidden = isEnter
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([shareButton.leadingAnchor.constraint(equalTo: roomIdButton.trailingAnchor, constant: 15), shareButton.centerYAnchor.constraint(equalTo: roomIdButton.centerYAnchor)])
        
        view.addSubview(onboardingLabel)
        onboardingLabel.isHidden = !isOnboarding
        NSLayoutConstraint.activate([onboardingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100), onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)])
        
        view.addSubview(backMenuButton)
        backMenuButton.isHidden = true
        backMenuButton.addTarget(self, action: #selector(backMenuButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([backMenuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), backMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), backMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), backMenuButton.heightAnchor.constraint(equalToConstant: 80)])
        
        addGestures()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func addGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(singleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action:  #selector(self.handleLongPress(_:)))
        view.addGestureRecognizer(longPress)
        
        let zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_ :)))
        view.addGestureRecognizer(zoomGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer?) {
        let tapCoordinate = sender?.location(in: view) ?? .zero
        drawGesture(gesture: .touch, center: tapCoordinate)
        playSound(named: "touch", type: "mp3")
        sendMessage(center: tapCoordinate, gesture: .touch)
        
        if isOnboarding && tapCounter == 0 {
            let seconds = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.onboardingLabel.text = "Отлично! Теперь попробуйте долго удерживать палец на одном месте экрана для распознания жеста\"Зажатие\""
                self.tapCounter += 1
            }
        }
    }
    
    @objc private func handlePinch(_ sender: UIPanGestureRecognizer?) {
        if sender?.state == .began {
            print("handlePinch")
            let tapCoordinate = sender?.location(in: view) ?? .zero
            drawGesture(gesture: .zoom, center: tapCoordinate)
            playSound(named: "zoom", type: "mp3")
            sendMessage(center: tapCoordinate, gesture: .zoom)
            
            if isOnboarding && tapCounter == 2 {
                let seconds = 6.7
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.onboardingLabel.text = "А теперь попробуйте повторить жест другого пользователя, для появления реакции"
                    self.tapCounter += 1
                    self.drawCenterZoomGif()
                }
            } 
            if isOnboarding && tapCounter == 3{
                didComplete = true
                self.messageService.playVibration(forResourse: "zoom", duration: 7.0)
                let seconds = 6.7
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.onboardingLabel.text = "Поздравляем, обучение пройдено! Приятного времяприпровождения в пространстве Mime"
                    self.tapCounter += 1
                    self.backMenuButton.isHidden = false
                }
            }
        }
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer?) {
        if sender?.state == .began {
            let tapCoordinate = sender?.location(in: view) ?? .zero
            drawGesture(gesture: .longPress, center: tapCoordinate)
            playSound(named: "long", type: "mp3")
            sendMessage(center: tapCoordinate, gesture: .longPress)
            
            if isOnboarding && tapCounter == 1 {
                let seconds = 3.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.onboardingLabel.text = "У вас отлично получается! Теперь попробуйте отвести пальцы друг от друга, словно пытаетесь увеличить контент на экране для распознания жеста\"Зум\""
                }
                tapCounter += 1
            }
        }
    }
    
    @objc
    private func quitDoorButtonTapped(){
        messageService.disconnect()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func gesturesButtonTapped(){
        navigationController?.pushViewController(GesturesViewController(), animated: true)
    }
    
    @objc
    private func roomIdButtonTapped(){
        if let roomId = roomId{
            UIPasteboard.general.string = roomId
            animateCopyLabel()
        }
    }
    
    @objc
    private func shareButtonTapped(){
        guard let roomId = self.roomId else{
            return
        }
        
        let content = "Привет! Заходи в мою комнату в приложении Mime mime://room/\(roomId)" /* если приложение не установлено, сначала скачай его по ссылке: https://apps.apple.com/ru/app/microsoft-word/id462054704?mt=12"*/
        
        let activityVC = UIActivityViewController.init(activityItems: [content], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc
    private func backMenuButtonTapped(){
        navigationController?.pushViewController(MenuViewController(isOnboarding: false), animated: true)
    }
    
    private func drawGesture(gesture: Message.GestureType, center: CGPoint){
        do {
            let gifName: String
            switch gesture{
            case.longPress:
                gifName = "longPress.gif"
            case .touch:
                gifName = "touch.gif"
            case .zoom:
                gifName = "zoom_fast.gif"
            }
            let gif = try UIImage(gifName: gifName)
            let gifView = UIImageView(gifImage: gif, loopCount: 1)
            gifView.delegate = self
            gifView.frame = CGRect(x: 0, y: 0, width: 1110 / 5, height: 1110 / 5)
            gifView.center = center
            view.insertSubview(gifView, belowSubview: topElementsStackView)
        } catch {
            print(error)
        }
    }
    
    private func drawCenterZoomGif()
    {
        do {
            let gifName = "zoom_fast.gif"
            let gif = try UIImage(gifName: gifName)
            let zoomGif = UIImageView(gifImage: gif, loopCount: .max)
            zoomGif.delegate = self
            zoomGif.frame = CGRect(x: 0, y: 0, width: 1110 / 5, height: 1110 / 5)
            zoomGif.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            view.insertSubview(zoomGif, belowSubview: topElementsStackView)
            self.zoomGif = zoomGif
        } catch {
            print(error)
        }
    }
    
    private func animateCopyLabel() {
        UIView.animate(withDuration: 0.75, animations : {
            self.copyLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 1, animations : {
                self.copyLabel.alpha = 0
            })
        }
    }
    
    private func animateEnterLabel() {
        UIView.animate(withDuration: 1, animations : {
            self.enterLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 2, animations : {
                self.enterLabel.alpha = 0
            })
        }
    }
    
    private func playSound(named: String, type: String) {
        let path = Bundle.main.path(forResource: named, ofType: type)!
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("couldn't load the file")
        }
    }
    
    func didConnectToRoomId(roomId: String) {
        DispatchQueue.main.async {
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 15)!]
            let attributedString = NSAttributedString(string: "Номер комнаты: \(roomId)", attributes: attributes)
            self.roomIdButton.setAttributedTitle(attributedString, for: .normal)
            self.roomId = roomId
        }
    }
    
    func didReceiveMessage(message: Message) {
        DispatchQueue.main.async {
            let coordiante = CGPoint(x: self.view.frame.width * message.x, y: self.view.frame.height * message.y)
            self.drawGesture(gesture: message.gesture, center: coordiante)
        }
    }
    
    func sendMessage(center: CGPoint, gesture: Message.GestureType) {
        let message = Message(x: center.x  / self.view.frame.width, y: center.y / self.view.frame.height, gesture: gesture, date: .now)
        messageService.sendMessage(message: message)
    }
    
    func failedConnectToRoom() {
        DispatchQueue.main.async {
            let allert = UIAlertController(title: "Ошибка", message: "Комнаты с таким кодом не существует. Попробуйте ещё раз", preferredStyle: .alert)
            allert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(allert, animated: true)
        }
    }
    
    func secondUserConnected() {
        DispatchQueue.main.async {
            if let roomId = self.roomId {
                let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 15)!]
                let attributedString = NSAttributedString(string: "Номер комнаты: \(roomId)", attributes: attributes)
                self.roomIdButton.setAttributedTitle(attributedString, for: .normal)
            }
            self.roomIdButton.isHidden = true
            self.shareButton.isHidden = true
            self.topSeparator.isHidden = true
            self.bottomSeparator.isHidden = true
            self.doorImage.image = UIImage(named: "activeDoor")
            self.doorImage.layer.shadowColor = CGColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)
            self.doorImage.layer.shadowRadius = 15.0
            self.doorImage.layer.shadowOpacity = 1
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = self.doorImage.layer.shadowOpacity
            animation.toValue = 0.0
            animation.duration = 2.0
            animation.autoreverses = true
            animation.repeatCount = .infinity
            self.doorImage.layer.add(animation, forKey: animation.keyPath)
            self.enterLabel.text = "Собеседник подключился"
            if self.isEnter{
                self.enterLabel.text = "Вы успешно подлючились к комнате"
            }
            self.animateEnterLabel()
        }
    }
    
    func secondUserDisconnected() {
        DispatchQueue.main.async {
            self.roomIdButton.isHidden = false
            self.shareButton.isHidden = false
            self.topSeparator.isHidden = false
            self.bottomSeparator.isHidden = false
            self.doorImage.image = UIImage(named: "inactiveDoor")
            self.doorImage.layer.removeAllAnimations()
            self.doorImage.layer.shadowOpacity = 0
            self.enterLabel.text = "Ваш собеседник покинул комнату"
            self.animateEnterLabel()
            self.isEnter = false
        }
    }
}

extension CallViewController:SwiftyGifDelegate {
    
    func gifDidStop(sender: UIImageView) {
        sender.removeFromSuperview()
    }
    
    func gifDidLoop(sender: UIImageView) {
        if sender == zoomGif && didComplete  {
            zoomGif?.removeFromSuperview()
            zoomGif = nil
        }
    }
}
