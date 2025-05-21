//
//  SettingsViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 13.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private let notificationService = NotificationService()
    
    private lazy var settingsLabel = MainFactory.topLabel(text: NSLocalizedString("settings", comment: ""))
    
    private lazy var helpLabel: UILabel = {
        let label = MainFactory.topLabel(text: NSLocalizedString("help", comment: ""))
        /*label.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(helpTapped))
        label.addGestureRecognizer(recognizer)*/
        return label
    }()
    
    private lazy var accountLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("account", comment: ""))

    private lazy var whiteThemeLabel = MainFactory.topLabel(text: NSLocalizedString("whiteTheme", comment: ""))
    
    private lazy var soundLabel = MainFactory.topLabel(text: NSLocalizedString("sound", comment: ""))
    
    private lazy var hapticsLabel = MainFactory.topLabel(text: NSLocalizedString("haptics", comment: ""))
    
    private lazy var timeLabel = MainFactory.topLabel(text: NSLocalizedString("notificationTime", comment: ""))
    
    private lazy var notificationsLabel = MainFactory.topLabel(text: NSLocalizedString("notifications", comment: ""))
    
    private lazy var switchWhiteTheme = MainFactory.switchButton()
    
    private lazy var switchSound = MainFactory.switchButton()
    
    private lazy var switchHaptics = MainFactory.switchButton()
    
    private lazy var switchNotifications = MainFactory.switchButton()
    
    private lazy var helpButton = MainFactory.imageButtonTemplate(imageName: "nextLine")
    
    private lazy var accountButton = MainFactory.imageButtonTemplate(imageName: "nextLine")
    
    private lazy var exitAccountButton = MainFactory.deleteButton(text: NSLocalizedString("logout", comment: ""))
    
    private lazy var helpSeparator = MainFactory.paleSeparator()
    
    private lazy var accountSeparator = MainFactory.paleSeparator()
    
    private lazy var whiteThemeSeparator = MainFactory.paleSeparator()

    private lazy var soundSeparator = MainFactory.paleSeparator()

    private lazy var hapticSeparator = MainFactory.paleSeparator()
    
    private lazy var notificationsSeparator = MainFactory.paleSeparator()
    
    private lazy var exitTopSeparator = MainFactory.separator()

    private lazy var exitBottomSeparator = MainFactory.separator()

    
    private lazy var timePicker: UIDatePicker = {
        var timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.locale = .current
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .compact
        timePicker.backgroundColor = .backgroundColor
        return timePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { success, error in
            DispatchQueue.main.async {
                self.switchNotifications.isEnabled = success
            }
        }
        
        view.addSubview(settingsLabel)
        view.addSubview(helpLabel)
        view.addSubview(whiteThemeLabel)
        view.addSubview(soundLabel)
        view.addSubview(hapticsLabel)
        view.addSubview(notificationsLabel)
        view.addSubview(timeLabel)
        view.addSubview(accountLabel)
        view.addSubview(switchWhiteTheme)
        view.addSubview(switchSound)
        view.addSubview(switchHaptics)
        view.addSubview(switchNotifications)
        view.addSubview(timePicker)
        view.addSubview(helpButton)
        view.addSubview(accountButton)
        view.addSubview(exitAccountButton)
        view.addSubview(helpSeparator)
        view.addSubview(whiteThemeSeparator)
        view.addSubview(soundSeparator)
        view.addSubview(hapticSeparator)
        view.addSubview(notificationsSeparator)
        view.addSubview(exitTopSeparator)
        view.addSubview(exitBottomSeparator)
        view.addSubview(accountSeparator)
        
        switchWhiteTheme.isOn = UserDefaults.standard.bool(forKey: "WhiteTheme")
        switchHaptics.isOn = UserDefaults.standard.bool(forKey: "HapticsActive")
        switchSound.isOn = UserDefaults.standard.bool(forKey: "SoundActive")
        switchNotifications.isOn = UserDefaults.standard.bool(forKey: "NotificationsActive")
        
        timeLabel.isHidden = !switchNotifications.isOn
        timePicker.isHidden = !switchNotifications.isOn
        let time = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "NotificationTime")) // TODO: set current time
        timePicker.date = time
        
        switchWhiteTheme.addTarget(self, action: #selector(switchWhiteThemeButtonTapped), for: .valueChanged)
        switchHaptics.addTarget(self, action: #selector(switchHapticsButtonTapped), for: .valueChanged)
        switchSound.addTarget(self, action: #selector(switchSoundButtonTapped), for: .valueChanged)
        switchNotifications.addTarget(self, action: #selector(switchNotificationsButtonTapped), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        exitAccountButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helpTapped), for: .touchUpInside)
        accountButton.addTarget(self, action: #selector(accountTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            settingsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        
            helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            helpLabel.heightAnchor.constraint(equalToConstant: 25),
            helpLabel.widthAnchor.constraint(equalToConstant: 192),
            helpLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 64.5),
            
            accountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            accountLabel.heightAnchor.constraint(equalToConstant: 25),
            accountLabel.widthAnchor.constraint(equalToConstant: 192),
            accountLabel.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 36),
        
            whiteThemeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            whiteThemeLabel.heightAnchor.constraint(equalToConstant: 25),
            whiteThemeLabel.widthAnchor.constraint(equalToConstant: 192),
            whiteThemeLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 36),
            
            soundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            soundLabel.heightAnchor.constraint(equalToConstant: 25),
            soundLabel.widthAnchor.constraint(equalToConstant: 192),
            soundLabel.topAnchor.constraint(equalTo: whiteThemeLabel.bottomAnchor, constant: 36),
            
            hapticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hapticsLabel.heightAnchor.constraint(equalToConstant: 25),
            hapticsLabel.widthAnchor.constraint(equalToConstant: 192),
            hapticsLabel.topAnchor.constraint(equalTo: soundLabel.bottomAnchor, constant: 36),
        
            notificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            notificationsLabel.heightAnchor.constraint(equalToConstant: 25),
            notificationsLabel.widthAnchor.constraint(equalToConstant: 192),
            notificationsLabel.topAnchor.constraint(equalTo: hapticsLabel.bottomAnchor, constant: 36),
            
            switchWhiteTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            switchWhiteTheme.centerYAnchor.constraint(equalTo: whiteThemeLabel.centerYAnchor),
        
            helpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            helpButton.centerYAnchor.constraint(equalTo: helpLabel.centerYAnchor),
            
            accountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            accountButton.centerYAnchor.constraint(equalTo: accountLabel.centerYAnchor),
        
            switchHaptics.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            switchHaptics.centerYAnchor.constraint(equalTo: hapticsLabel.centerYAnchor),
        
            switchSound.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            switchSound.centerYAnchor.constraint(equalTo: soundLabel.centerYAnchor),
        
            switchNotifications.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            switchNotifications.centerYAnchor.constraint(equalTo: notificationsLabel.centerYAnchor),
        
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            timeLabel.heightAnchor.constraint(equalToConstant: 25),
            timeLabel.widthAnchor.constraint(equalToConstant: 192),
            timeLabel.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 36),
        
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            timePicker.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
        
            exitAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitAccountButton.heightAnchor.constraint(equalToConstant: 25),
            exitAccountButton.widthAnchor.constraint(equalToConstant: 192),
            exitAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        
            helpSeparator.leadingAnchor.constraint(equalTo: helpLabel.leadingAnchor),
            helpSeparator.trailingAnchor.constraint(equalTo: helpButton.trailingAnchor),
            helpSeparator.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 18),
            helpSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            accountSeparator.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor),
            accountSeparator.trailingAnchor.constraint(equalTo: accountButton.trailingAnchor),
            accountSeparator.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 18),
            accountSeparator.heightAnchor.constraint(equalToConstant: 1),
        
            whiteThemeSeparator.leadingAnchor.constraint(equalTo: whiteThemeLabel.leadingAnchor),
            whiteThemeSeparator.trailingAnchor.constraint(equalTo: switchWhiteTheme.trailingAnchor),
            whiteThemeSeparator.topAnchor.constraint(equalTo: whiteThemeLabel.bottomAnchor, constant: 18),
            whiteThemeSeparator.heightAnchor.constraint(equalToConstant: 1),
        
            soundSeparator.leadingAnchor.constraint(equalTo: soundLabel.leadingAnchor),
            soundSeparator.trailingAnchor.constraint(equalTo: switchSound.trailingAnchor),
            soundSeparator.topAnchor.constraint(equalTo: soundLabel.bottomAnchor, constant: 18),
            soundSeparator.heightAnchor.constraint(equalToConstant: 1),
        
            hapticSeparator.leadingAnchor.constraint(equalTo: hapticsLabel.leadingAnchor),
            hapticSeparator.trailingAnchor.constraint(equalTo: switchHaptics.trailingAnchor),
            hapticSeparator.topAnchor.constraint(equalTo: hapticsLabel.bottomAnchor, constant: 18),
            hapticSeparator.heightAnchor.constraint(equalToConstant: 1),
        
            notificationsSeparator.leadingAnchor.constraint(equalTo: notificationsLabel.leadingAnchor),
            notificationsSeparator.trailingAnchor.constraint(equalTo: switchNotifications.trailingAnchor),
            notificationsSeparator.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 12.5),
            notificationsSeparator.heightAnchor.constraint(equalToConstant: 1),
        
            exitTopSeparator.heightAnchor.constraint(equalToConstant: 1),
            exitTopSeparator.leadingAnchor.constraint(equalTo: exitAccountButton.leadingAnchor),
            exitTopSeparator.trailingAnchor.constraint(equalTo: exitAccountButton.trailingAnchor),
            exitTopSeparator.bottomAnchor.constraint(equalTo: exitAccountButton.topAnchor),
            
            exitBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            exitBottomSeparator.trailingAnchor.constraint(equalTo: exitAccountButton.trailingAnchor),
            exitBottomSeparator.leadingAnchor.constraint(equalTo: exitAccountButton.leadingAnchor),
            exitBottomSeparator.topAnchor.constraint(equalTo: exitAccountButton.bottomAnchor)])
    }
    
    @objc
    private func switchWhiteThemeButtonTapped(){
        var appearance = self.traitCollection.userInterfaceStyle
        if switchWhiteTheme.isOn {
            UserDefaults.standard.setValue(switchWhiteTheme.isOn, forKey: "WhiteTheme")
            appearance = .light
            navigationController?.navigationBar.tintColor = .textColor //UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = appearance
        } else {
            UserDefaults.standard.setValue(switchWhiteTheme.isOn, forKey: "WhiteTheme")
            appearance = .dark
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = appearance
            navigationController?.navigationBar.tintColor = .textColor //UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }
    }
    
    @objc
    private func switchSoundButtonTapped(){
        UserDefaults.standard.setValue(switchSound.isOn, forKey: "SoundActive")
    }
    
    @objc
    private func switchHapticsButtonTapped(){
        UserDefaults.standard.setValue(switchHaptics.isOn, forKey: "HapticsActive")
    }
    
    @objc
    private func switchNotificationsButtonTapped(){
        if switchNotifications.isOn {
            timeLabel.isHidden = false
            timePicker.isHidden = false
            UserDefaults.standard.setValue(switchNotifications.isOn, forKey: "NotificationsActive")
        }
        if !switchNotifications.isOn {
            timeLabel.isHidden = true
            timePicker.isHidden = true
            UserDefaults.standard.setValue(switchNotifications.isOn, forKey: "NotificationsActive")
        }
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker)
    {
        let time = sender.date
        UserDefaults.standard.setValue(time.timeIntervalSince1970, forKey: "NotificationTime")
        notificationService.addNotification()
    }
    
    @objc
    private func logoutButtonTapped(){
        networkService.deleteToken()
        UserDefaults.standard.interlocutors = []
        navigationController?.setViewControllers([StartViewController()], animated: true)
    }

    @objc
    private func helpTapped(){
        navigationController?.pushViewController(GesturesViewController(), animated: true)
    }
    
    @objc
    private func accountTapped(){
        navigationController?.pushViewController(AccountViewController(), animated: true)
    }
}
