//
//  JoinSessionCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/19/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol JoinSessionCellDelegate {
    func joinSession(with code: String)
}

class JoinSessionCell: UITableViewCell, UITextFieldDelegate {
    
    var joinSessionCellDelegate: JoinSessionCellDelegate!
    
    var joinView: UIView!
    var sessionTextField: UITextField!
    var joinButton: UIButton!
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        joinView = UIView()
        joinView.layer.cornerRadius = 8
        joinView.layer.masksToBounds = true
        addSubview(joinView)
        
        sessionTextField = UITextField()
        let sessionAttributedString = NSMutableAttributedString(string: "Enter session code")
        sessionAttributedString.addAttribute(.font, value: UIFont._16RegularFont, range: NSRange(location: 0, length: sessionAttributedString.length))
        sessionTextField.attributedPlaceholder = sessionAttributedString
        sessionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        sessionTextField.addTarget(self, action: #selector(beganTypingCode), for: .editingChanged)
        sessionTextField.returnKeyType = .done
        sessionTextField.delegate = self
        sessionTextField.backgroundColor = .white
        joinView.addSubview(sessionTextField)
        
        joinButton = UIButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.titleLabel?.font = UIFont._18MediumFont
        joinButton.setTitleColor(.clickerDarkGray, for: .normal)
        joinButton.backgroundColor = .clickerLightGray
        joinButton.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        joinView.addSubview(joinButton)
        
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        joinView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(self.frame.width * 0.048)
            make.right.equalToSuperview().offset(self.frame.width * -0.048)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(55)
        }
        
        sessionTextField.snp.makeConstraints { make in
            make.width.equalTo(joinView.snp.width).multipliedBy(0.75)
            make.height.equalTo(joinView.snp.height)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        joinButton.snp.makeConstraints{ make in
            make.left.equalTo(sessionTextField.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func beganTypingCode(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.uppercased()

            if validate(code: text) {
                joinButton.backgroundColor = .clickerGreen
                joinButton.setTitleColor(.white, for: .normal)
            } else {
                joinButton.backgroundColor = .clickerLightGray
                joinButton.setTitleColor(.clickerDarkGray, for: .normal)
            }
        } else {
            joinButton.backgroundColor = .clickerLightGray
            joinButton.setTitleColor(.clickerDarkGray, for: .normal)
        }
    }
    
    func validate(code: String) -> Bool {
        if (code.count == 6 && !code.contains(" ")) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - DELEGATION
    
    @objc func joinSession(){
        if let code = sessionTextField.text {
            joinSessionCellDelegate.joinSession(with: code)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
