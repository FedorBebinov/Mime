//
//  AwardsView.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 06.05.2024.
//

import UIKit

class AwardsView: UIView{

    enum Award {
        case background
        case accessory
        case border
        case gesture
    }
    let award: Award
    let imageName: String
    private lazy var titleLabel = MainFactory.textLabel(text: NSLocalizedString("gotAward", comment: ""))
    private lazy var viewImage = MainFactory.imageView(name: "")
    private lazy var viewLabel = MainFactory.textLabel(text: "")

    private lazy var actionButton = MainFactory.separatedButton(text: NSLocalizedString("setBackground", comment: ""))
    private lazy var topLine = MainFactory.separator()
    private lazy var bottomLine = MainFactory.separator()

    init(award: Award, imageName: String, labelText: String, unlocked: Bool) {
        self.award = award
        self.imageName = imageName
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .awardColor
        self.layer.cornerRadius = 10

        self.addSubview(viewImage)

        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)

        viewImage.image = UIImage(named: imageName)
        viewLabel.text = labelText
        viewLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        viewLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            viewImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])

        updateActionButtonTitle()

        if unlocked {
            self.addSubview(titleLabel)
            self.addSubview(actionButton)
            self.addSubview(topLine)
            self.addSubview(bottomLine)
            topLine.isHidden = award == .gesture
            bottomLine.isHidden = award == .gesture
            NSLayoutConstraint.activate([
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),

                viewImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),

                topLine.bottomAnchor.constraint(equalTo: actionButton.topAnchor),
                topLine.widthAnchor.constraint(equalTo: actionButton.widthAnchor, multiplier: 1),
                topLine.heightAnchor.constraint(equalToConstant: 1),
                topLine.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),

                actionButton.topAnchor.constraint(equalTo: viewImage.bottomAnchor, constant: 25),
                actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),

                bottomLine.topAnchor.constraint(equalTo: actionButton.bottomAnchor),
                bottomLine.widthAnchor.constraint(equalTo: actionButton.widthAnchor, multiplier: 1),
                bottomLine.heightAnchor.constraint(equalToConstant: 1),
                bottomLine.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),

            ])

            if award == .gesture {
                self.addSubview(viewLabel)
                NSLayoutConstraint.activate([
                    viewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                    viewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                    viewLabel.topAnchor.constraint(equalTo: viewImage.bottomAnchor, constant: 25),
                    viewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
                ])
            }
        } else {
            self.addSubview(viewLabel)
            NSLayoutConstraint.activate([
                viewImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),

                viewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                viewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                viewLabel.topAnchor.constraint(equalTo: viewImage.bottomAnchor, constant: 25),
                viewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func actionButtonPressed() {
        switch award {
        case .background:
            if UserDefaults.standard.customBackground == imageName {
                UserDefaults.standard.customBackground = nil
            } else {
                UserDefaults.standard.customBackground = imageName
            }
        case .accessory:
            UserDefaults.standard.accessoryEnabled.toggle()
        case .border:
            UserDefaults.standard.borderEnabled.toggle()
        case .gesture:
            break
        }
        updateActionButtonTitle()
    }

    private func updateActionButtonTitle() {
        let title: String
        switch award {
        case .background:
            if let customBackground = UserDefaults.standard.customBackground {
                title = customBackground == imageName ? NSLocalizedString("removeBackground", comment: "") : NSLocalizedString("setBackground", comment: "")
            } else {
                title = NSLocalizedString("setBackground", comment: "")
            }
        case .accessory:
            title = UserDefaults.standard.accessoryEnabled ? NSLocalizedString("removeAccessory", comment: "") : NSLocalizedString("setAccessory", comment: "")
        case .border:
            title = UserDefaults.standard.borderEnabled ? NSLocalizedString("removeBorder", comment: "") : NSLocalizedString("setBorder", comment: "")
        case .gesture:
            title = ""
        }
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWithSize(size: 12)!]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        actionButton.setAttributedTitle(attributedString, for: .normal)
    }
}
