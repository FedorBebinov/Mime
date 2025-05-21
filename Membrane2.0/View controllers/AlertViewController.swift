//
//  AlertViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 23.10.2024.
//

import UIKit

class AlertViewController: UIViewController{
    
    weak var delegate: PredeleteDelegate?
    
    private lazy var messageLabel: UILabel = {
        var label = UILabel()
        label = MainFactory.textLabel(text: NSLocalizedString("deleteAlert", comment: ""))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.borderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteButton = MainFactory.separatedDeleteButton(text: NSLocalizedString("delete", comment: ""))
    
    private lazy var cancelButton = MainFactory.separatedButton(text: NSLocalizedString("cancel", comment: ""))
    
    private lazy var deleteTopSeparator = MainFactory.separator()
    
    private lazy var deleteBottomSeparator = MainFactory.separator()
    
    private lazy var cancelTopSeparator = MainFactory.separator()
    
    private lazy var cancelBottomSeparator = MainFactory.separator()
    
    override func viewDidLoad() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(alertView)
        alertView.addSubview(messageLabel)
        alertView.addSubview(cancelButton)
        alertView.addSubview(deleteButton)
        alertView.addSubview(deleteTopSeparator)
        alertView.addSubview(deleteBottomSeparator)
        alertView.addSubview(cancelTopSeparator)
        alertView.addSubview(cancelBottomSeparator)
        
        deleteButton.addTarget(self, action: #selector(deleteButtontapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtontapped), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 170),
            alertView.widthAnchor.constraint(equalToConstant: 280),
            
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -30),
            messageLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30),
            
            cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 52),
            cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -35),
            
            deleteButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -52),
            deleteButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -35),
            
            deleteTopSeparator.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            deleteTopSeparator.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            deleteTopSeparator.bottomAnchor.constraint(equalTo: deleteButton.topAnchor),
            deleteTopSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            
            deleteBottomSeparator.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            deleteBottomSeparator.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            deleteBottomSeparator.topAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            deleteBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            cancelTopSeparator.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            cancelTopSeparator.trailingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            cancelTopSeparator.bottomAnchor.constraint(equalTo: cancelButton.topAnchor),
            cancelTopSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            
            cancelBottomSeparator.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            cancelBottomSeparator.trailingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            cancelBottomSeparator.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            cancelBottomSeparator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    @objc
    func cancelButtontapped(){
        dismiss(animated: false)
    }
    
    @objc
    func deleteButtontapped(){
        delegate?.deleteButtonTapped()
        dismiss(animated: false)
    }
    
}

protocol PredeleteDelegate: AnyObject {
    func deleteButtonTapped()
}
