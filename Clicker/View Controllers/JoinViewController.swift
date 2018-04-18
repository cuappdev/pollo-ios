//
//  JoinViewController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {
    
    let joinButtonSize: CGSize = CGSize(width: 83.5, height: 44)
    let codeTextFieldHeight: CGFloat = 47
    let edgePadding: CGFloat = 18
    let textFieldPadding: CGFloat = 1.5
    let exitButtonHeight: CGFloat = 32
    let bottomPadding: CGFloat = 11
    
    var session: Socket!
    var dismissController: UIViewController!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var codeTextField: UITextField!
    var joinButton: UIButton!
    var exitButton: UIButton!
    var popupHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Join"

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        view.backgroundColor = .clickerDeepBlack

        setupViews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        codeTextField = UITextField(frame: CGRect(x: edgePadding, y: edgePadding, width: view.frame.size.width - edgePadding * 2, height: codeTextFieldHeight))
        codeTextField.delegate = self
        codeTextField.layer.cornerRadius = codeTextFieldHeight / 2
        codeTextField.borderStyle = .none
        codeTextField.font = ._16MediumFont
        codeTextField.backgroundColor = .white
        codeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: edgePadding, height: codeTextFieldHeight))
        codeTextField.leftViewMode = .always
        codeTextField.attributedPlaceholder = NSAttributedString(string: "Enter a code", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGray, NSAttributedStringKey.font: UIFont._16MediumFont])
        view.addSubview(codeTextField)
        
        let joinButtonView = UIView(frame: CGRect(x: 0, y: 0, width: joinButtonSize.width + textFieldPadding * 2, height: joinButtonSize.height + textFieldPadding * 2))
        joinButton = UIButton(frame: CGRect(x: textFieldPadding, y: textFieldPadding, width: joinButtonSize.width, height: joinButtonSize.height))
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.titleLabel?.font = ._16SemiboldFont
        joinButton.titleLabel?.textAlignment = .center
        joinButton.backgroundColor = .clickerGreen
        joinButton.layer.cornerRadius = joinButtonSize.height / 2
        joinButton.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        joinButtonView.addSubview(joinButton)
        
        codeTextField.rightView = joinButtonView
        codeTextField.rightViewMode = .always

        exitButton = UIButton(frame: CGRect(x: 0, y: popupHeight - bottomPadding - exitButtonHeight, width: exitButtonHeight, height: exitButtonHeight))
        exitButton.center.x = view.center.x
        exitButton.setImage(#imageLiteral(resourceName: "ExitIcon"), for: .normal)
        exitButton.backgroundColor = .clear
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    @objc func joinSession() {
        if let code = codeTextField.text {
            if code != "" {
                StartSession(code: code).make()
                    .done { session in
                        // TODO: join session
                        print("session joined")
                    }.catch { error in
                        print(error)
                }
            }
        }
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TEXT VIEW DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - KEYBOARD
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    @objc func hideKeyboard() {
        // Hide keyboard when user taps outside of text field on popup view
        codeTextField.resignFirstResponder()
    }
    
}
