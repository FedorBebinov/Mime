//
//  SecurityQuestionViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 04.10.2024.
//

import UIKit

class SecurityQuestionViewController: UIViewController{
    
    private let networkingService = NetworkService()
    
    private let isRecovery: Bool
    
    private lazy var topLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("chooseQuestion", comment: ""))
    
    private lazy var securityQuestionLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("securityQuestion", comment: ""))
    
    private lazy var responseLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("response", comment: ""))
    
    private lazy var securityQuestionSeparator = MainFactory.paleSeparator()
    
    private lazy var responseSeparator = MainFactory.paleSeparator()
    
    private lazy var selectLabel: UILabel = MainFactory.topLabel(text: NSLocalizedString("select", comment: ""))
    
    private lazy var responseTextField = MainFactory.textField()
    
    private lazy var explanationLabel: UILabel = MainFactory.miniLabel(text: NSLocalizedString("explanation", comment: ""))
    
    private let securityQuestions = [NSLocalizedString("characterName", comment: ""),
                                     NSLocalizedString("whereToMove", comment: ""),
                                     NSLocalizedString("favoriteSubject", comment: ""),
                                     NSLocalizedString("childDream", comment: ""),
                                     NSLocalizedString("petName", comment: ""),]
    private var isDropped = false
    
    private lazy var tapGestureRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handleTap))
        recognizer.isEnabled = false
        return recognizer
    }()
    
    private lazy var dropDownButton: UIButton = {
        let image = UIImage(resource: .dropDown).withRenderingMode(.alwaysTemplate)
        let button = MainFactory.imageButton(image: image)
        button.tintColor = .textColor
        return button
    }()
    
    private lazy var questionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SecurityQuestionCell.self, forCellReuseIdentifier: "SecurityQuestionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var continueButton = MainFactory.disabledMainButton(text: NSLocalizedString("continue", comment: ""))
    
    private var continueButtonBottomConstraint: NSLayoutConstraint?
    
    init(isRecovery: Bool){
        self.isRecovery = isRecovery
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor

        //view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(topLabel)
        view.addSubview(securityQuestionLabel)
        view.addSubview(securityQuestionSeparator)
        view.addSubview(selectLabel)
        view.addSubview(securityQuestionSeparator)
        view.addSubview(dropDownButton)
        view.addSubview(responseLabel)
        view.addSubview(responseTextField)
        view.addSubview(responseSeparator)
        view.addSubview(explanationLabel)
        view.addSubview(continueButton)
        view.addSubview(questionsTableView)
        
        dropDownButton.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        responseTextField.delegate = self
        
        if isRecovery {
            topLabel.text = NSLocalizedString("passwordRecovery", comment: "")
            explanationLabel.isHidden = true
        }
        
        continueButtonBottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
        NSLayoutConstraint.activate([
            //view.keyboardLayoutGuide.topAnchor
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            securityQuestionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            securityQuestionLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 52),
            
            selectLabel.topAnchor.constraint(equalTo: securityQuestionLabel.bottomAnchor, constant: 18),
            selectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            selectLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            //selectLabel.heightAnchor.constraint(equalToConstant: 25),
            
            securityQuestionSeparator.leadingAnchor.constraint(equalTo: selectLabel.leadingAnchor),
            securityQuestionSeparator.trailingAnchor.constraint(equalTo: selectLabel.trailingAnchor),
            securityQuestionSeparator.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 18),
            securityQuestionSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            dropDownButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            dropDownButton.centerYAnchor.constraint(equalTo: selectLabel.centerYAnchor),
            
            responseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            responseLabel.topAnchor.constraint(equalTo: securityQuestionSeparator.bottomAnchor, constant: 33),
            
            responseTextField.topAnchor.constraint(equalTo: responseLabel.bottomAnchor),
            responseTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            responseTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            responseTextField.heightAnchor.constraint(equalToConstant: 50),
            
            responseSeparator.leadingAnchor.constraint(equalTo: responseTextField.leadingAnchor),
            responseSeparator.trailingAnchor.constraint(equalTo: responseTextField.trailingAnchor),
            responseSeparator.topAnchor.constraint(equalTo: responseTextField.bottomAnchor),
            responseSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            explanationLabel.topAnchor.constraint(equalTo: responseSeparator.bottomAnchor, constant: 13),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 80),
            continueButtonBottomConstraint!,
            
            questionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            questionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            questionsTableView.topAnchor.constraint(equalTo: securityQuestionSeparator.bottomAnchor, constant: 23),
            questionsTableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -69)
        ])
        
        //subscribeToKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateButtonState() {
        if selectLabel.text == NSLocalizedString("select", comment: ""){
            return
        }
        continueButton.isEnabled = !(responseTextField.text?.isEmpty ?? true)
    }
    
    private func subscribeToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func errorAlert(tittle:String, message: String){
        //activityIndicatorView.stopAnimating()
        //loadingView.isHidden = true
        let allert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "OK", style: .default))
        present(allert, animated: true)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
        let keyboardHeight = keyboardFrame.cgRectValue.height
            
        continueButtonBottomConstraint?.constant = -keyboardHeight
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
        tapGestureRecognizer.isEnabled.toggle()
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification){
        continueButtonBottomConstraint?.constant = -45
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            }
        tapGestureRecognizer.isEnabled.toggle()
    }
    
    @objc
    func handleTap(){
        view.endEditing(true)
    }
    
    @objc
    func dropDownButtonTapped(){
        questionsTableView.isHidden.toggle()
        isDropped.toggle()
        isDropped ? dropDownButton.setImage(UIImage(resource: .dropBack), for: .normal) : dropDownButton.setImage(UIImage(resource: .dropDown), for: .normal)
    }
    
    @objc
    func continueButtonTapped(){
        Task {
            if isRecovery {
                do {
                    let securityInfo = try await networkingService.getSecurityInfo()
                    if securityInfo.secretQuestion != selectLabel.text {
                        await MainActor.run(body: {
                            errorAlert(tittle: "Ошибка", message: "Секретный вопрос не совпадает с заданным")
                            return
                            })
                    }
                    else if securityInfo.secretAnswer != responseTextField.text {
                        await MainActor.run(body: {
                            errorAlert(tittle: "Ошибка", message: "Неверный ответ на секретный вопрос")
                            return
                            })
                    } else {
                        await MainActor.run {
                            navigationController?.pushViewController(ChangePasswordViewController(wasForgotten: true), animated: true)
                        }
                    }
                }
            } else {
                let securityInfo = SecurityQuestion(secretQuestion: selectLabel.text ?? "", secretAnswer: responseTextField.text ?? "")
                
                do {
                    try await networkingService.saveSecurityQuestion(data: securityInfo)
                    await MainActor.run {
                        navigationController?.pushViewController(ChooseShapeViewController(), animated: true)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
extension SecurityQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: "SecurityQuestionCell") as! SecurityQuestionCell
        cell.setText(text: securityQuestions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        selectLabel.text = securityQuestions[indexPath.row]
        dropDownButtonTapped()
    }
    
}

extension SecurityQuestionViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            continueButtonTapped()
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        textField.text = updatedText
                
        updateButtonState()

        return false
    }
}
