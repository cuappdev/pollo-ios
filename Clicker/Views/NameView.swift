//
//  BlurView.swift
//  Clicker
//
//  Created by eoin on 4/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol NameViewDelegate: class {
    func nameViewDidUpdateSessionName()
}

class NameView: UIView, UITextFieldDelegate {

    // MARK: - View vars
    var titleField: UITextField!
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    // MARK: - Data vars
    var session: Session!
    weak var delegate: NameViewDelegate?
    private let networking: Networking = URLSession.shared.request
    
    init (frame: CGRect, session: Session, delegate: NameViewDelegate) {
        super.init(frame: frame)
        self.session = session
        self.delegate = delegate
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupViews() {
        
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
        titleField = UITextField()
        titleField.attributedPlaceholder = NSAttributedString(string: "Give your group a name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey2, NSAttributedStringKey.font: UIFont._24MediumFont])
        if session.code != session.name {
            titleField.text = session.name
        }
        titleField.font = ._24MediumFont
        titleField.textColor = .clickerWhite
        titleField.textAlignment = .center
        titleField.delegate = self
        titleField.becomeFirstResponder()
        titleField.keyboardType = .asciiCapable
        addSubview(titleField)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let superview = superview else { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let iphoneXBottomPadding = safeAreaInsets.bottom
            titleField.snp.remakeConstraints { remake in
                remake.centerX.equalToSuperview()
                remake.width.equalToSuperview()
                remake.height.equalTo(27)
                remake.centerY.equalTo((superview.bounds.height - keyboardSize.height - iphoneXBottomPadding) / 2)
            }
            titleField.superview?.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            titleField.snp.remakeConstraints { remake in
                remake.centerX.equalToSuperview()
                remake.width.equalToSuperview()
                remake.height.equalTo(27)
                remake.centerY.equalToSuperview()
            }
            titleField.superview?.layoutIfNeeded()
        }
    }
    
    func setupConstraints() {
        blurEffectView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        titleField.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func updateSession(id: Int, name: String, code: String) -> Future<Response<Session>> {
        return networking(Endpoint.updateSession(id: id, name: name, code: code)).decode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var name: String
        if let text = textField.text {
            name = text
        } else {
            name = session.code
        }
        updateSession(id: session.id, name: name, code: session.code).observe { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value:
                    self.session.name = name
                    self.delegate?.nameViewDidUpdateSessionName()
                    self.removeFromSuperview()
                case .error(let error):
                    print("error: ", error)
                }
            }
        }
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
