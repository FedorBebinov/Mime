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

    private var repeatAudioPlayer: AVAudioPlayer = .init()

    private var soundActive: Bool {
        UserDefaults.standard.bool(forKey: "SoundActive")
    }

    private lazy var enterLabel = MainFactory.hidenLabel(text: NSLocalizedString("interlocutorConnected", comment: ""))
    
    private var isEnter: Bool
    
    private var isOnboarding: Bool
    
    private lazy var onboardingLabel = MainFactory.gestureRoomTextLabel(text: "А теперь попробуем потренировать жесты. Нажмите на экран для распознания жеста\"Касание\"")
    
    private var tapCounter = 0
    
    private lazy var backMenuButton = MainFactory.mainButton(text: "Вернуться в меню")
    
    private lazy var roomIdButton = MainFactory.separatedRoomButton(text: NSLocalizedString("roomNumber:", comment: ""))
    
    private lazy var shareButton = MainFactory.imageButton(imageName: "shareButton")
    
    private lazy var topSeparator = MainFactory.separator()
    
    private lazy var bottomSeparator = MainFactory.separator()
    
    private lazy var copyLabel = MainFactory.hidenLabel(text: NSLocalizedString("codeCopyed", comment: ""))
    
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
    
    private var isUserInRoom = false
    
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
        view.backgroundColor = UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1)
        NotificationCenter.default.addObserver(forName: UIDevice.deviceDidShakeNotification, object: nil, queue: .main) { _ in
            self.playShakeAnimationIfNeeded()
        }
                
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
        NSLayoutConstraint.activate([roomIdButton.heightAnchor.constraint(equalToConstant: 25), roomIdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), roomIdButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)])
        
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

        if let customBackground = UserDefaults.standard.customBackground {
            let backgroundImageView = UIImageView(image: .init(named: customBackground))
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(backgroundImageView, at: 0)
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func addGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(singleTap)
        
        let twoFingersTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTwoFingersTap))
        twoFingersTap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(twoFingersTap)
        
        let threeFingersTap = UITapGestureRecognizer(target: self, action: #selector(self.handleThreeFingersTap))
        threeFingersTap.numberOfTouchesRequired = 3
        view.addGestureRecognizer(threeFingersTap)
        
        let fourFingersTap = UITapGestureRecognizer(target: self, action: #selector(self.handleFourFingersTap))
        fourFingersTap.numberOfTouchesRequired = 4
        view.addGestureRecognizer(fourFingersTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action:  #selector(self.handleLongPress))
        view.addGestureRecognizer(longPress)
        
        let twoFingerslongPress = UILongPressGestureRecognizer(target: self, action:  #selector(self.handleTwoFingersLongPress))
        twoFingerslongPress.numberOfTouchesRequired = 2
        view.addGestureRecognizer(twoFingerslongPress)
        
        let threeFingerslongPress = UILongPressGestureRecognizer(target: self, action:  #selector(self.handleThreeFingersLongPress))
        threeFingerslongPress.numberOfTouchesRequired = 3
        view.addGestureRecognizer(threeFingerslongPress)
        
        let fourFingerslongPress = UILongPressGestureRecognizer(target: self, action:  #selector(self.handleFourFingersLongPress))
        fourFingerslongPress.numberOfTouchesRequired = 4
        view.addGestureRecognizer(fourFingerslongPress)
        
        let zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch))
        view.addGestureRecognizer(zoomGesture)
        
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        moveGesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(moveGesture)
        
        let twoFingersMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleTwoFingersPan))
        twoFingersMoveGesture.minimumNumberOfTouches = 2
        twoFingersMoveGesture.maximumNumberOfTouches = 2
        view.addGestureRecognizer(twoFingersMoveGesture)
        
        let threeFingersMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleThreeFingersPan))
        threeFingersMoveGesture.minimumNumberOfTouches = 3
        threeFingersMoveGesture.maximumNumberOfTouches = 3
        view.addGestureRecognizer(threeFingersMoveGesture)
        
        let fourFingersMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleFourFingersPan))
        fourFingersMoveGesture.minimumNumberOfTouches = 4
        fourFingersMoveGesture.maximumNumberOfTouches = 4
        view.addGestureRecognizer(fourFingersMoveGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer?) {
        guard let sender else {
            return
        }
        let tapCoordinate = sender.location(in: view)
        drawGesture(gesture: .touch, points: [tapCoordinate])
        if !isUserInRoom {
            playSound(named: "1touch", type: "mp3")
        }
        AchievementService.shared.checkMessageType(points: [tapCoordinate], gesture: "tap")
        sendMessage(points: [tapCoordinate], gesture: .touch)
        
        if isOnboarding && tapCounter == 0 {
            let seconds = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.onboardingLabel.text = NSLocalizedString("callOnboarding1", comment: "")
                self.tapCounter += 1
            }
        }
    }
    
    @objc private func handleTwoFingersTap(_ sender: UITapGestureRecognizer?) {
        guard let sender else {
            return
        }
        var points = [CGPoint]()
        points.append(sender.location(ofTouch: 0, in: view))
        points.append(sender.location(ofTouch: 1, in: view))
        drawGesture(gesture: .touch, points: points)
        AchievementService.shared.checkMessageType(points: points, gesture: "tap")
        if !isUserInRoom {
            playSound(named: "2touch", type: "mp3")
        }
        sendMessage(points: points, gesture: .touch)
        
        if isOnboarding && tapCounter == 4 {
            let seconds = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.onboardingLabel.text = NSLocalizedString("callOnboarding1", comment: "")
                self.tapCounter += 1
                self.drawCenterZoomGif()
            }
        }
        
    }
    
    @objc private func handleThreeFingersTap(_ sender: UITapGestureRecognizer?) {
        guard let sender else {
            return
        }
        var points = [CGPoint]()
        points.append(sender.location(ofTouch: 0, in: view))
        points.append(sender.location(ofTouch: 1, in: view))
        points.append(sender.location(ofTouch: 2, in: view))
        drawGesture(gesture: .touch, points: points)
        AchievementService.shared.checkMessageType(points: points, gesture: "tap")
        if !isUserInRoom {
            playSound(named: "3touch", type: "mp3")
        }
        sendMessage(points: points, gesture: .touch)
        
    }
    
    @objc private func handleFourFingersTap(_ sender: UITapGestureRecognizer?) {
        guard let sender else {
            return
        }
        var points = [CGPoint]()
        points.append(sender.location(ofTouch: 0, in: view))
        points.append(sender.location(ofTouch: 1, in: view))
        points.append(sender.location(ofTouch: 2, in: view))
        points.append(sender.location(ofTouch: 3, in: view))
        drawGesture(gesture: .touch, points: points)
        AchievementService.shared.checkMessageType(points: points, gesture: "tap")
        if !isUserInRoom {
            playSound(named: "4touch", type: "mp3")
        }
        sendMessage(points: points, gesture: .touch)
    }
    
    @objc private func handlePinch(_ sender: UIPanGestureRecognizer?) {
        if sender?.state == .began {
            print("handlePinch")
            let tapCoordinate = sender?.location(in: view) ?? .zero
            drawGesture(gesture: .zoom, points: [tapCoordinate])
            AchievementService.shared.checkMessageType(points: [tapCoordinate], gesture: "zoom")
            if !isUserInRoom {
                playSound(named: "zoomSound", type: "mp3")
            }
            sendMessage(points: [tapCoordinate], gesture: .zoom)
            
            if isOnboarding && tapCounter == 3 {
                let seconds = 6.7
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.onboardingLabel.text = NSLocalizedString("callOnboarding3", comment: "")
                    self.tapCounter += 1
                }
            } 
            if isOnboarding && tapCounter == 5{
                didComplete = true
                self.messageService.playVibration(forResourse: "zoomSound", duration: 7.0)
                let seconds = 6.7
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.onboardingLabel.text = NSLocalizedString("callOnboarding4", comment: "")
                    self.tapCounter += 1
                    self.backMenuButton.isHidden = false
                }
            }
        }
    }
    
    @objc private func handleFourFingersLongPress(_ sender: UILongPressGestureRecognizer?) {
        guard let sender else {
            return
        }
        if sender.state == .began {
            var points = [CGPoint]()
            points.append(sender.location(ofTouch: 0, in: view))
            points.append(sender.location(ofTouch: 1, in: view))
            points.append(sender.location(ofTouch: 2, in: view))
            points.append(sender.location(ofTouch: 3, in: view))
            drawGesture(gesture: .touch, points: points)
            if !isUserInRoom {
                playSound(named: "4touch", type: "mp3")
            }
            sendMessage(points: points, gesture: .touch)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if sender.state != .ended {
                    //let tapCoordinate = sender.location(in: self.view)
                    AchievementService.shared.checkMessageType(points: points, gesture: "longPress")
                    self.drawGesture(gesture: .longPress, points: points)
                    if !self.isUserInRoom {
                        self.playSound(named: "4hold", type: "mp3")
                    }
                    self.sendMessage(points: points, gesture: .longPress)
                }
            }
        }
    }
    
    @objc private func handleThreeFingersLongPress(_ sender: UILongPressGestureRecognizer?) {
        guard let sender else {
            return
        }
        if sender.state == .began {
            var points = [CGPoint]()
            points.append(sender.location(ofTouch: 0, in: view))
            points.append(sender.location(ofTouch: 1, in: view))
            points.append(sender.location(ofTouch: 2, in: view))
            drawGesture(gesture: .touch, points: points)
            if !isUserInRoom {
                playSound(named: "3touch", type: "mp3")
            }
            sendMessage(points: points, gesture: .touch)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if sender.state != .ended {
                    //let tapCoordinate = sender.location(in: self.view)
                    AchievementService.shared.checkMessageType(points: points, gesture: "longPress")
                    self.drawGesture(gesture: .longPress, points: points)
                    if !self.isUserInRoom {
                        self.playSound(named: "3hold", type: "mp3")
                    }
                    self.sendMessage(points: points, gesture: .longPress)
                }
            }
        }
    }
    
    @objc private func handleTwoFingersLongPress(_ sender: UILongPressGestureRecognizer?) {
        guard let sender else {
            return
        }
        if sender.state == .began {
            var points = [CGPoint]()
            points.append(sender.location(ofTouch: 0, in: view))
            points.append(sender.location(ofTouch: 1, in: view))
            drawGesture(gesture: .touch, points: points)
            if !isUserInRoom {
                playSound(named: "2touch", type: "mp3")
            }
            sendMessage(points: points, gesture: .touch)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if sender.state != .ended {
                    //let tapCoordinate = sender.location(in: self.view)
                    AchievementService.shared.checkMessageType(points: points, gesture: "longPress")
                    self.drawGesture(gesture: .longPress, points: points)
                    if !self.isUserInRoom {
                        self.playSound(named: "2hold", type: "mp3")
                    }
                    self.sendMessage(points: points, gesture: .longPress)
                }
            }
        }
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer?) {
        guard let sender else {
            return
        }
        
        if sender.state == .began {
            let tapCoordinate = sender.location(in: view)
            drawGesture(gesture: .touch, points: [tapCoordinate])
            if !isUserInRoom {
                playSound(named: "1touch", type: "mp3")
            }
            sendMessage(points: [tapCoordinate], gesture: .touch)
            let seconds = 1.2
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if sender.state != .ended {
                    //let tapCoordinate = sender.location(in: self.view)
                    AchievementService.shared.checkMessageType(points: [tapCoordinate], gesture: "longPress")
                    self.drawGesture(gesture: .longPress, points: [tapCoordinate])
                    if !self.isUserInRoom {
                        self.playSound(named: "1hold", type: "mp3")
                    }
                    self.sendMessage(points: [tapCoordinate], gesture: .longPress)
                }
            }
            
            if isOnboarding && tapCounter == 1 {
                let seconds = 3.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.onboardingLabel.text = NSLocalizedString("callOnboarding5", comment: "")
                }
                tapCounter += 1
            }
        }
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer?) {
        handleUniversalPan(sender)
        if isOnboarding && tapCounter == 2 {
            let seconds = 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.onboardingLabel.text = NSLocalizedString("callOnboarding6", comment: "")
            }
            tapCounter += 1
        }
        
    }
    
    @objc private func handleTwoFingersPan(_ sender: UIPanGestureRecognizer?) {
        handleUniversalPan(sender)
    }
    
    @objc private func handleThreeFingersPan(_ sender: UIPanGestureRecognizer?) {
        handleUniversalPan(sender)
    }
    
    @objc private func handleFourFingersPan(_ sender: UIPanGestureRecognizer?) {
        handleUniversalPan(sender)
    }
    
    private func handleUniversalPan(_ sender: UIPanGestureRecognizer?) {
        guard let sender else {
            return
        }
        switch sender.state {
        case .began:
            AchievementService.shared.trackSendMessage()
            if soundActive, !isUserInRoom {
                let path: String
                switch sender.numberOfTouches {
                case 1:
                    path = Bundle.main.path(forResource: "1_finger_pan", ofType: "mp3")!
                case 2:
                    path = Bundle.main.path(forResource: "2_finger_pan", ofType: "mp3")!
                case 3:
                    path = Bundle.main.path(forResource: "3_finger_pan", ofType: "mp3")!
                case 4:
                    path = Bundle.main.path(forResource: "4_finger_pan", ofType: "mp3")!
                default:
                    path = Bundle.main.path(forResource: "1_finger_pan", ofType: "mp3")!
                }
                let url = URL(fileURLWithPath: path)
                repeatAudioPlayer = try! .init(contentsOf: url)
                repeatAudioPlayer.numberOfLoops = -1
                repeatAudioPlayer.play()
            }
        case .changed:
            var points = [CGPoint]()
            for touch in 0 ..< sender.numberOfTouches {
                points.append(sender.location(ofTouch: touch, in: view))
            }
            drawDot(points: points)
            sendMessage(points: points, gesture: .pan)
            AchievementService.shared.checkMessageType(points: points, gesture: "pan")
        case .ended, .cancelled, .failed:
            repeatAudioPlayer.stop()
        default:
            break
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
    
    private func playShakeAnimationIfNeeded(){
        guard AchievementService.shared.experimenterAchievement.unlocked else {
            return
        }
        do {
            let gif = try UIImage(gifName: "confetti2")
            let gifView = UIImageView(gifImage: gif, loopCount: 1)
            gifView.delegate = self
            gifView.frame = CGRect(x: 0, y: 0, width: view.bounds.height, height: view.bounds.height)
            gifView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            view.insertSubview(gifView, belowSubview: topElementsStackView)
        } catch {
            print(error)
        }
        playSound(named: "сonfetti", type: "mp3")
        UIImpactFeedbackGenerator().impactOccurred()
    }
    
    private func drawGesture(gesture: Message.GestureType, points: [CGPoint]){
        do {
            let gifName: String
            switch gesture{
            case.longPress:
                switch points.count{
                case 1:
                    gifName = "hold1_new.gif"
                case 2:
                    gifName = "hold-2-new.gif"
                case 3:
                    gifName = "long-press3.gif"
                case 4:
                    gifName = "hold4_new2.gif"
                default:
                    gifName = "hold4.gif"
                }
            case .touch:
                switch points.count{
                case 1:
                    gifName = "touch1_final.gif"
                case 2:
                    gifName = "touch-2-neeew.gif"
                case 3:
                    gifName = "touch3_1.gif"
                case 4:
                    gifName = "touch4_d.gif"
                default:
                    gifName = "touch4_d.gif"
                }
            case .zoom:
                gifName = "zoom_fast.gif"
            case .pan:
                drawDot(points: points)
                return
            }
            if gifName == "hold4.gif" {
                let gif = try UIImage(gifName: gifName)
                let gifView = UIImageView(gifImage: gif, loopCount: 1)
                gifView.delegate = self
                
                gifView.frame = CGRect(x: 0, y: 0, width: view.bounds.height * 1.5, height: view.bounds.height * 1.5)
                let minX = points.min { point1, point2 in
                    point1.x < point2.x
                }?.x ?? 0
                let maxX = points.max { point1, point2 in
                    point1.x < point2.x
                }?.x ?? 0
                let minY = points.min { point1, point2 in
                    point1.y < point2.y
                }?.y ?? 0
                let maxY = points.max { point1, point2 in
                    point1.y < point2.y
                }?.y ?? 0
                let center = CGPoint(x: (maxX + minX) / 2, y: (maxY + minY) / 2)
                gifView.center = center
                view.insertSubview(gifView, belowSubview: topElementsStackView)
            } else{
                for point in points {
                    let gif = try UIImage(gifName: gifName)
                    let gifView = UIImageView(gifImage: gif, loopCount: 1)
                    gifView.delegate = self
                    if gifName == "hold2_50.gif"{
                        gifView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
                    } else if gifName == "touch3_1.gif"{
                        gifView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                    }else if gifName == "long-press3.gif"{
                        gifView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
                    }else{
                        gifView.frame = CGRect(x: 0, y: 0, width: 222, height: 222)
                    }
                    gifView.center = point
                    view.insertSubview(gifView, belowSubview: topElementsStackView)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func drawDot(points: [CGPoint]) {
        //let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageName: String
        switch points.count{
        case 1:
            imageName = "motion1"
        case 2:
            imageName = "motion2"
        case 3:
            imageName = "motion3"
        case 4:
            imageName = "motion4"
        default:
            imageName = "motion1"
        }
        
        
            /*view.backgroundColor = .gray
             view.layer.shadowColor = UIColor.gray.cgColor
             view.layer.shadowRadius = 5.0
             view.layer.shadowOpacity = 1
             view.layer.cornerRadius = 20*/
            //let imageView = UIImageView(image: UIImage(named: "motion1"))
        
        for point in points {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            imageView.image = UIImage(named: imageName)
            imageView.center = point
            self.view.addSubview(imageView)
            let seconds = 1.5
            /*DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
             view.removeFromSuperview()
             }*/
            let animator = UIViewPropertyAnimator(duration: seconds, curve: .linear) {
                imageView.alpha = 0
                imageView.transform = .init(scaleX: 0.1, y: 0.1)
            }
            animator.startAnimation()
            animator.addCompletion { _ in
                imageView.removeFromSuperview()
            }
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
            if soundActive {
                audioPlayer.play()
            }
        } catch {
            print("couldn't load the file")
        }
    }
    
    func didConnectToRoomId(roomId: String) {
        DispatchQueue.main.async {
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 15)!]
            let attributedString = NSAttributedString(string: NSLocalizedString("roomNumber:", comment: "") + roomId, attributes: attributes)
            self.roomIdButton.setAttributedTitle(attributedString, for: .normal)
            self.roomId = roomId
        }
    }
    
    func didReceiveMessage(message: Message) {
        DispatchQueue.main.async {
            let points = message.points.map { messagePoint in
                CGPoint(x: self.view.frame.width * messagePoint.x, y: self.view.frame.height * messagePoint.y)
            }
            self.drawGesture(gesture: message.gesture, points: points)
            let soundName: String
            switch message.gesture {
            case .touch:
                switch points.count {
                case 1:
                    soundName = "1touch"
                case 2:
                    soundName = "2touch"
                case 3:
                    soundName = "3touch"
                case 4:
                    soundName = "4touch"
                default:
                    return
                }
            case .longPress:
                switch points.count {
                case 1:
                    soundName = "1hold"
                case 2:
                    soundName = "2hold"
                case 3:
                    soundName = "3hold"
                case 4:
                    soundName = "4hold"
                default:
                    return
                }
            case .zoom:
                soundName = "zoomSound"
            case .pan:
                return
            }
            self.playSound(named: soundName, type: "mp3")
        }
    }
    
    func sendMessage(points: [CGPoint], gesture: Message.GestureType) {
        let messagePoints = points.map { cgPoint in
            return Message.Point(x: cgPoint.x / self.view.frame.width, y: cgPoint.y / self.view.frame.height)
        }
        let message = Message(points: messagePoints, gesture: gesture, date: .now)
        messageService.sendMessage(message: message)
        if gesture != .pan {
            AchievementService.shared.trackSendMessage()
        }
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
            self.isUserInRoom = true
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
            self.enterLabel.text = NSLocalizedString("connected", comment: "")
            if self.isEnter{
                self.enterLabel.text = NSLocalizedString("you_connected", comment: "")
            }
            self.animateEnterLabel()
        }
    }
    
    func secondUserDisconnected() {
        DispatchQueue.main.async {
            self.isUserInRoom = false
            self.roomIdButton.isHidden = false
            self.shareButton.isHidden = false
            self.topSeparator.isHidden = false
            self.bottomSeparator.isHidden = false
            self.doorImage.image = UIImage(named: "inactiveDoor")
            self.doorImage.layer.removeAllAnimations()
            self.doorImage.layer.shadowOpacity = 0
            self.enterLabel.text = NSLocalizedString("left_room", comment: "")
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
