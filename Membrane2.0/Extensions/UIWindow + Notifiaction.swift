//
//  UIWindow + Notifiaction.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.05.2024.
//

import UIKit

extension UIWindow {
    func showNotification(achievement: String){
        DispatchQueue.main.async {
            let view = UIView()
            view.backgroundColor = .borderColor
            view.layer.cornerRadius = 40.5
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            if let rootViewController = self.rootViewController as? UINavigationController, let topViewController = rootViewController.topViewController {
                if topViewController is CallViewController {
                    NSLayoutConstraint.activate([view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -1), view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30), view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30), view.heightAnchor.constraint(equalToConstant: 74)])
                } else {
                    NSLayoutConstraint.activate([view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 13), view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30), view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),  view.heightAnchor.constraint(equalToConstant: 74)])
                }
            }
            let textLabel = UILabel()
            textLabel.text = String(format: NSLocalizedString("completed_award", comment: ""), arguments: [achievement])
            textLabel.textColor = .textColor
            textLabel.font = .fontWithSize(size: 12)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(textLabel)
            
            NSLayoutConstraint.activate([textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
            
            view.alpha = 0
            
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
            animator.addAnimations {
                view.alpha = 1
            }
            animator.startAnimation()
            let animatorHide = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
            animatorHide.addAnimations {
                view.alpha = 0
            }
            animatorHide.startAnimation(afterDelay: 3)
        }
    }
}
