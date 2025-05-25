//
//  AchievementsViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 23.04.2024.
//

import UIKit

class AchievementsViewController: UIViewController {
    
    private lazy var achievementsLabel = MainFactory.topLabel(text: NSLocalizedString("achievements", comment: ""))

    private lazy var messagesLabel = MainFactory.topLabel(text: NSLocalizedString("communicative", comment: ""))

    private lazy var messagesMiniLabel = MainFactory.miniLabel(text: NSLocalizedString("communicativeText", comment: ""))
    
    //private lazy var messageNumLabel = MainFactory.textLabel(text: "\(AchievementService.shared.messageCounter)/100")
    
    private lazy var messagesRadioImage: UILabel = {
        let label = MainFactory.topLabel(text:"")
        let unlocked = AchievementService.shared.messageAchievement.unlocked
        label.text = unlocked ? NSLocalizedString("doneVypoln", comment: "") : "\(AchievementService.shared.messagesCount)/100"
        return label
    }()

    private lazy var daysLabel = MainFactory.topLabel(text: NSLocalizedString("habitue", comment: ""))

    private lazy var daysMiniLabel = MainFactory.miniLabel(text: NSLocalizedString("habitueText", comment: ""))

    //private lazy var daysNumLabel = MainFactory.textLabel(text: "\(AchievementService.shared.usingDays)/15")
    
    private lazy var daysRadioImage = MainFactory.topLabel(text: AchievementService.shared.daysAchievement.unlocked ? NSLocalizedString("doneVypoln", comment: "") : "\(AchievementService.shared.usingDays)/15")

    private lazy var callsLabel = MainFactory.topLabel(text: NSLocalizedString("closeConnect", comment: ""))

    private lazy var callsMiniLabel = MainFactory.miniLabel(text: NSLocalizedString("closeConnectText", comment: ""))

    private lazy var callsRadioImage: UILabel = {
        let maxCalls = AchievementService.shared.callsCounter?.values.max(by: { value1, value2 in
            if let value1 = value1 as? Int, let value2 = value2 as? Int{
                return value1 < value2
            }
            return false
            })
        return MainFactory.topLabel(text: "\(maxCalls ?? 0)/5")
    }()
    
    //private lazy var callsRadioImage = MainFactory.imageView(name: "radio")
    
    private lazy var friendlyLabel = MainFactory.topLabel(text: NSLocalizedString("friendly", comment: ""))

    private lazy var friendlyMiniLabel = MainFactory.miniLabel(text: NSLocalizedString("friendlyText", comment: ""))

   // private lazy var friendlyNumLabel = MainFactory.textLabel(text: "0/2")
    
    private lazy var friendlyRadioImage = MainFactory.topLabel(text: AchievementService.shared.friendsAchievement.unlocked ? NSLocalizedString("doneVypoln", comment: "") : "\(AchievementService.shared.callsCounter?.count ?? 0)/2")

    private lazy var experimenterLabel = MainFactory.topLabel(text: NSLocalizedString("experimenter", comment: ""))

    private lazy var experimenterMiniLabel = MainFactory.miniLabel(text: NSLocalizedString("experimenterText", comment: ""))

    //private lazy var experimenterNumLabel = MainFactory.textLabel(text: "0/8")
    
    private lazy var experimenterRadioImage = MainFactory.topLabel(text: AchievementService.shared.experimenterAchievement.unlocked ? NSLocalizedString("doneVypoln", comment: "") : "\(AchievementService.shared.uniqueGestures.count)/8")

    private lazy var daysTopSeparator = MainFactory.separator()
    
    private lazy var daysBottomSeparator = MainFactory.separator()
    
    private lazy var callsBottomSeparator = MainFactory.separator()
    
    private lazy var friendlyBottomSeparator = MainFactory.separator()
        
    private lazy var experimenterBottomSeparator = MainFactory.separator()
    
    private lazy var awardsButton = MainFactory.mainButton(text: NSLocalizedString("awards", comment: ""))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(achievementsLabel)
        view.addSubview(messagesLabel)
        view.addSubview(messagesMiniLabel)
        //view.addSubview(messageNumLabel)
        view.addSubview(messagesRadioImage)
        view.addSubview(daysLabel)
        view.addSubview(daysMiniLabel)
        //view.addSubview(daysNumLabel)
        view.addSubview(daysRadioImage)
        view.addSubview(callsLabel)
        view.addSubview(callsMiniLabel)
        //view.addSubview(callsNumLabel)
        view.addSubview(callsRadioImage)
        view.addSubview(friendlyLabel)
        view.addSubview(friendlyMiniLabel)
        //view.addSubview(friendlyNumLabel)
        view.addSubview(friendlyRadioImage)
        view.addSubview(experimenterLabel)
        view.addSubview(experimenterMiniLabel)
        //view.addSubview(experimenterNumLabel)
        view.addSubview(experimenterRadioImage)
        view.addSubview(daysTopSeparator)
        view.addSubview(daysBottomSeparator)
        view.addSubview(callsBottomSeparator)
        view.addSubview(friendlyBottomSeparator)
        view.addSubview(experimenterBottomSeparator)
        view.addSubview(awardsButton)
        
        experimenterMiniLabel.numberOfLines = 2
        
        awardsButton.addTarget(self, action: #selector(awardsButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            achievementsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            achievementsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            achievementsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
        
            messagesLabel.topAnchor.constraint(equalTo: achievementsLabel.bottomAnchor, constant: 52),
            messagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            messagesRadioImage.centerYAnchor.constraint(equalTo: messagesLabel.centerYAnchor),
            messagesRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            messagesMiniLabel.topAnchor.constraint(equalTo: messagesLabel.bottomAnchor, constant: 10),
            messagesMiniLabel.leadingAnchor.constraint(equalTo: messagesLabel.leadingAnchor),
            
            //messageNumLabel.centerYAnchor.constraint(equalTo: messagesMiniLabel.centerYAnchor),
            //messageNumLabel.leadingAnchor.constraint(equalTo: messagesMiniLabel.trailingAnchor, constant: 10),
            
            daysLabel.topAnchor.constraint(equalTo: messagesLabel.bottomAnchor, constant: 65),
            daysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            daysRadioImage.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            daysRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            daysMiniLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 10),
            daysMiniLabel.leadingAnchor.constraint(equalTo: daysLabel.leadingAnchor),
            
            //daysNumLabel.centerYAnchor.constraint(equalTo: daysMiniLabel.centerYAnchor),
            //daysNumLabel.leadingAnchor.constraint(equalTo: daysMiniLabel.trailingAnchor, constant: 10),
            
            daysTopSeparator.heightAnchor.constraint(equalToConstant: 1),
            daysTopSeparator.leadingAnchor.constraint(equalTo: daysLabel.leadingAnchor),
            daysTopSeparator.trailingAnchor.constraint(equalTo: daysRadioImage.trailingAnchor),
            daysTopSeparator.bottomAnchor.constraint(equalTo: daysLabel.topAnchor, constant: -20),
            
            daysBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            daysBottomSeparator.trailingAnchor.constraint(equalTo: daysRadioImage.trailingAnchor),
            daysBottomSeparator.leadingAnchor.constraint(equalTo: daysLabel.leadingAnchor),
            daysBottomSeparator.topAnchor.constraint(equalTo: daysMiniLabel.bottomAnchor, constant: 20),
            
            callsLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 65),
            callsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            callsRadioImage.centerYAnchor.constraint(equalTo: callsLabel.centerYAnchor),
            callsRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            callsMiniLabel.topAnchor.constraint(equalTo: callsLabel.bottomAnchor, constant: 10),
            callsMiniLabel.leadingAnchor.constraint(equalTo: callsLabel.leadingAnchor),
            
            //callsNumLabel.centerYAnchor.constraint(equalTo: callsMiniLabel.centerYAnchor),
            //callsNumLabel.leadingAnchor.constraint(equalTo: callsMiniLabel.trailingAnchor, constant: 10),
            
            callsBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            callsBottomSeparator.trailingAnchor.constraint(equalTo: callsRadioImage.trailingAnchor),
            callsBottomSeparator.leadingAnchor.constraint(equalTo: callsLabel.leadingAnchor),
            callsBottomSeparator.topAnchor.constraint(equalTo: callsMiniLabel.bottomAnchor, constant: 20),
            
            friendlyLabel.topAnchor.constraint(equalTo: callsLabel.bottomAnchor, constant: 65),
            friendlyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            friendlyRadioImage.centerYAnchor.constraint(equalTo: friendlyLabel.centerYAnchor),
            friendlyRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            friendlyMiniLabel.topAnchor.constraint(equalTo: friendlyLabel.bottomAnchor, constant: 10),
            friendlyMiniLabel.leadingAnchor.constraint(equalTo: friendlyLabel.leadingAnchor),
            
            //friendlyNumLabel.centerYAnchor.constraint(equalTo: friendlyMiniLabel.centerYAnchor),
            //friendlyNumLabel.leadingAnchor.constraint(equalTo: friendlyMiniLabel.trailingAnchor, constant: 10),
            
            friendlyBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            friendlyBottomSeparator.trailingAnchor.constraint(equalTo: friendlyRadioImage.trailingAnchor),
            friendlyBottomSeparator.leadingAnchor.constraint(equalTo: friendlyLabel.leadingAnchor),
            friendlyBottomSeparator.topAnchor.constraint(equalTo: friendlyMiniLabel.bottomAnchor, constant: 20),
            
            experimenterLabel.topAnchor.constraint(equalTo: friendlyLabel.bottomAnchor, constant: 65),
            experimenterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            
            experimenterRadioImage.centerYAnchor.constraint(equalTo: experimenterLabel.centerYAnchor),
            experimenterRadioImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            experimenterMiniLabel.topAnchor.constraint(equalTo: experimenterLabel.bottomAnchor, constant: 10),
            experimenterMiniLabel.leadingAnchor.constraint(equalTo: experimenterLabel.leadingAnchor),
            experimenterMiniLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -135),
            
            awardsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            awardsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            awardsButton.heightAnchor.constraint(equalToConstant: 80),
            awardsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            //experimenterNumLabel.centerYAnchor.constraint(equalTo: experimenterMiniLabel.centerYAnchor, constant: 5),
            //experimenterNumLabel.leadingAnchor.constraint(equalTo: experimenterMiniLabel.trailingAnchor),
            
            /*experimenterBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            experimenterBottomSeparator.trailingAnchor.constraint(equalTo: experimenterRadioImage.trailingAnchor),
            experimenterBottomSeparator.leadingAnchor.constraint(equalTo: experimenterLabel.leadingAnchor),
            experimenterBottomSeparator.topAnchor.constraint(equalTo: experimenterMiniLabel.bottomAnchor, constant: 20),*/
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc
    func awardsButtonTapped(){
        navigationController?.pushViewController(AwardsViewController(), animated: true)
    }
}
