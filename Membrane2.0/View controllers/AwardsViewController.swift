//
//  AwardsViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 04.05.2024.
//

import UIKit

class AwardsViewController: UIViewController {
    
    private lazy var awardsLabel = MainFactory.topLabel(text: NSLocalizedString("awards", comment: ""))

    private lazy var fon1Block = MainFactory.imageButton(imageName: "block1")
    private lazy var lockFon1: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var fon2Block = MainFactory.imageButton(imageName: "block2")
    private lazy var lockFon2: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var fon3Block = MainFactory.imageButton(imageName: "block3")
    private lazy var lockFon3: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var fon4Block = MainFactory.imageButton(imageName: "block4")
    private lazy var lockFon4: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var fon5Block = MainFactory.imageButton(imageName: "block5")
    private lazy var lockFon5: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var fon6Block = MainFactory.imageButton(imageName: "block6")
    private lazy var lockFon6: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var nickNameBlock = MainFactory.imageButton(imageName: "block7")
    private lazy var lockNickName: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var avatarNameBlock = MainFactory.imageButton(imageName: "block8")
    private lazy var lockAvatarName: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var gestureBlock = MainFactory.imageButton(imageName: "block9")
    private lazy var lockGesture: UIImageView = {
        let image = UIImage(resource: .lock).withRenderingMode(.alwaysTemplate)
        let imageView = MainFactory.imageView(image: image)
        imageView.tintColor = .textColor
        return imageView
    }()
    private lazy var loadingView = MainFactory.loadingView()

    var awardsView: AwardsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(awardsLabel)
        view.addSubview(fon1Block)
        view.addSubview(fon2Block)
        view.addSubview(fon3Block)
        view.addSubview(fon4Block)
        view.addSubview(fon5Block)
        view.addSubview(fon6Block)
        view.addSubview(nickNameBlock)
        view.addSubview(avatarNameBlock)
        view.addSubview(gestureBlock)
        view.addSubview(lockFon1)
        view.addSubview(lockFon2)
        view.addSubview(lockFon3)
        view.addSubview(lockFon4)
        view.addSubview(lockFon5)
        view.addSubview(lockFon6)
        view.addSubview(lockGesture)
        view.addSubview(lockNickName)
        view.addSubview(lockAvatarName)
        view.addSubview(loadingView)
        
        let loadingTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLoadingTap))
        loadingView.addGestureRecognizer(loadingTap)
        
        fon1Block.addTarget(self, action: #selector(fon1BlockButtonTapped), for: .touchUpInside)
        fon2Block.addTarget(self, action: #selector(fon2BlockButtonTapped), for: .touchUpInside)
        fon3Block.addTarget(self, action: #selector(fon3BlockButtonTapped), for: .touchUpInside)
        fon4Block.addTarget(self, action: #selector(fon4BlockButtonTapped), for: .touchUpInside)
        fon5Block.addTarget(self, action: #selector(fon5BlockButtonTapped), for: .touchUpInside)
        fon6Block.addTarget(self, action: #selector(fon6BlockButtonTapped), for: .touchUpInside)
        nickNameBlock.addTarget(self, action: #selector(nickNameBlockButtonTapped), for: .touchUpInside)
        avatarNameBlock.addTarget(self, action: #selector(avatarNameBlockButtonTapped), for: .touchUpInside)
        gestureBlock.addTarget(self, action: #selector(gestureBlockButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            awardsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            awardsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            awardsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        
            fon1Block.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            fon1Block.topAnchor.constraint(equalTo: awardsLabel.bottomAnchor, constant: 52),
            
            lockFon1.leadingAnchor.constraint(equalTo: fon1Block.leadingAnchor, constant: 6),
            lockFon1.topAnchor.constraint(equalTo: fon1Block.topAnchor, constant: 6),
        
            fon2Block.centerYAnchor.constraint(equalTo: fon1Block.centerYAnchor),
            fon2Block.leadingAnchor.constraint(equalTo: fon1Block.trailingAnchor, constant: 15),
            
            lockFon2.leadingAnchor.constraint(equalTo: fon2Block.leadingAnchor, constant: 6),
            lockFon2.topAnchor.constraint(equalTo: fon2Block.topAnchor, constant: 6),
        
            fon3Block.centerYAnchor.constraint(equalTo: fon1Block.centerYAnchor),
            fon3Block.leadingAnchor.constraint(equalTo: fon2Block.trailingAnchor, constant: 15),
            
            lockFon3.leadingAnchor.constraint(equalTo: fon3Block.leadingAnchor, constant: 6),
            lockFon3.topAnchor.constraint(equalTo: fon3Block.topAnchor, constant: 6),
        
            fon4Block.topAnchor.constraint(equalTo: fon1Block.bottomAnchor, constant: 15),
            fon4Block.centerXAnchor.constraint(equalTo: fon1Block.centerXAnchor),
            
            lockFon4.leadingAnchor.constraint(equalTo: fon4Block.leadingAnchor, constant: 6),
            lockFon4.topAnchor.constraint(equalTo: fon4Block.topAnchor, constant: 6),
        
            fon5Block.topAnchor.constraint(equalTo: fon2Block.bottomAnchor, constant: 15),
            fon5Block.centerXAnchor.constraint(equalTo: fon2Block.centerXAnchor),
            
            lockFon5.leadingAnchor.constraint(equalTo: fon5Block.leadingAnchor, constant: 6),
            lockFon5.topAnchor.constraint(equalTo: fon5Block.topAnchor, constant: 6),
        
            fon6Block.topAnchor.constraint(equalTo: fon3Block.bottomAnchor, constant: 15),
            fon6Block.centerXAnchor.constraint(equalTo: fon3Block.centerXAnchor),
            
            lockFon6.leadingAnchor.constraint(equalTo: fon6Block.leadingAnchor, constant: 6),
            lockFon6.topAnchor.constraint(equalTo: fon6Block.topAnchor, constant: 6),
        
            nickNameBlock.topAnchor.constraint(equalTo: fon4Block.bottomAnchor, constant: 15),
            nickNameBlock.centerXAnchor.constraint(equalTo: fon4Block.centerXAnchor),
            
            lockNickName.leadingAnchor.constraint(equalTo: nickNameBlock.leadingAnchor, constant: 6),
            lockNickName.topAnchor.constraint(equalTo: nickNameBlock.topAnchor, constant: 6),
        
            avatarNameBlock.topAnchor.constraint(equalTo: fon5Block.bottomAnchor, constant: 15),
            avatarNameBlock.centerXAnchor.constraint(equalTo: fon5Block.centerXAnchor),
            
            lockAvatarName.leadingAnchor.constraint(equalTo: avatarNameBlock.leadingAnchor, constant: 6),
            lockAvatarName.topAnchor.constraint(equalTo: avatarNameBlock.topAnchor, constant: 6),
        
            gestureBlock.topAnchor.constraint(equalTo: fon6Block.bottomAnchor, constant: 15),
            gestureBlock.centerXAnchor.constraint(equalTo: fon6Block.centerXAnchor),
            
            lockGesture.leadingAnchor.constraint(equalTo: gestureBlock.leadingAnchor, constant: 6),
            lockGesture.topAnchor.constraint(equalTo: gestureBlock.topAnchor, constant: 6)])


        lockFon1.isHidden = AchievementService.shared.messageAchievement.unlocked
        lockFon2.isHidden = AchievementService.shared.messageAchievement.unlocked
        lockFon3.isHidden = AchievementService.shared.messageAchievement.unlocked

        lockFon4.isHidden = AchievementService.shared.callsAchievement.unlocked
        lockFon5.isHidden = AchievementService.shared.callsAchievement.unlocked
        lockFon6.isHidden = AchievementService.shared.callsAchievement.unlocked

        lockNickName.isHidden = AchievementService.shared.daysAchievement.unlocked
        lockAvatarName.isHidden = AchievementService.shared.friendsAchievement.unlocked
        lockGesture.isHidden = AchievementService.shared.experimenterAchievement.unlocked
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc
    func handleLoadingTap(){
        loadingView.isHidden = true
        awardsView?.removeFromSuperview()
        awardsView = nil
    }
    
    @objc
    func fon1BlockButtonTapped(){
        showAwardView(award: .background,
                      imageName: "awardBackground1",
                      labelText: NSLocalizedString("communicativeAward", comment: ""),
                      unlocked: AchievementService.shared.messageAchievement.unlocked)
    }
    
    @objc
    func fon2BlockButtonTapped(){
        showAwardView(award: .background,
                      imageName: "awardBackground2",
                      labelText: NSLocalizedString("communicativeAward", comment: ""),
                      unlocked: AchievementService.shared.messageAchievement.unlocked)
    }
    
    @objc
    func fon3BlockButtonTapped(){
        showAwardView(award: .background,
                      imageName: "awardBackground3",
                      labelText: NSLocalizedString("communicativeAward", comment: ""),
                      unlocked: AchievementService.shared.messageAchievement.unlocked)
    }
    
    @objc
    func fon4BlockButtonTapped(){
        showAwardView(award: .background,
                      imageName: "awardBackground4",
                      labelText: NSLocalizedString("closeConnectAward", comment: ""),
                      unlocked: AchievementService.shared.callsAchievement.unlocked)
    }
    
    @objc
    func fon5BlockButtonTapped(){
        showAwardView(award: .background,
                      imageName: "awardBackground5",
                      labelText: NSLocalizedString("closeConnectAward", comment: ""),
                      unlocked: AchievementService.shared.callsAchievement.unlocked)
    }
    
    @objc
    func fon6BlockButtonTapped(){
        showAwardView(award: .background,
                      imageName: "awardBackground6",
                      labelText: NSLocalizedString("closeConnectAward", comment: ""),
                      unlocked: AchievementService.shared.callsAchievement.unlocked)
    }
    
    @objc
    func nickNameBlockButtonTapped(){
        showAwardView(award: .accessory,
                      imageName: "awardName",
                      labelText: NSLocalizedString("habitueAward", comment: ""),
                      unlocked: AchievementService.shared.daysAchievement.unlocked)
    }
    
    @objc
    func avatarNameBlockButtonTapped(){
        showAwardView(award: .border,
                      imageName: "awardAvatar",
                      labelText: NSLocalizedString("friendlyAward", comment: ""),
                      unlocked: AchievementService.shared.friendsAchievement.unlocked)
    }
    
    @objc
    func gestureBlockButtonTapped(){
        let lockedText = NSLocalizedString("experimenterAwardLocked", comment: "")
        let unlockedText = NSLocalizedString("experimenterAwardUnlocked", comment: "")
        showAwardView(award: .gesture,
                      imageName: "awardGesture",
                      labelText: AchievementService.shared.experimenterAchievement.unlocked ? unlockedText : lockedText,
                      unlocked: AchievementService.shared.experimenterAchievement.unlocked)
    }

    func showAwardView(award: AwardsView.Award,
                       imageName: String, labelText: String, unlocked: Bool) {
        let awardsView = AwardsView(award: award,
                                    imageName: imageName,
                                    labelText: labelText,
                                    unlocked: unlocked)
        view.addSubview(awardsView)
        NSLayoutConstraint.activate([
            awardsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            awardsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            awardsView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingView.isHidden = false
        self.awardsView = awardsView
    }
}

extension UserDefaults {

    var customBackground: String? {
        get {
            string(forKey: "customBackground")
        }
        set {
            set(newValue, forKey: "customBackground")
        }
    }

    var accessoryEnabled: Bool {
        get {
            bool(forKey: "accessoryEnabled")
        }
        set {
            set(newValue, forKey: "accessoryEnabled")
        }
    }

    var borderEnabled: Bool {
        get {
            bool(forKey: "borderEnabled")
        }
        set {
            set(newValue, forKey: "borderEnabled")
        }
    }
}
