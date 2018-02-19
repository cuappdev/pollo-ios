//
//  JoinSessionCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/19/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol JoinSessionCellDelegate {
    func joinSession(textField:UITextField, isValidCode: Bool)
}

class JoinSessionCell: UITableViewCell {
    
    var joinSessionCellDelegate: JoinSessionCellDelegate!
    
    var joinLabel: UILabel!
    var joinView: UIView!
    var sessionTextField: UITextField!
    var joinButton: UIButton!
    
    var isValidCode: Bool! = false
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        joinLabel = UILabel()
        joinLabel.text = "Join A Session"
        joinLabel.font = UIFont._16SemiboldFont
        joinLabel.textColor = .clickerMediumGray
        addSubview(joinLabel)
        
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
        
        joinLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: self.frame.width - 36, height: 19))
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(self.frame.height * 0.1101949025)
        }
        
        joinView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(self.frame.width * 0.048)
            make.right.equalToSuperview().offset(self.frame.width * 0.048 * -1)
            make.top.equalTo(joinLabel.snp.bottom).offset(10)
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
            validateCode(code: text)
            
            if isValidCode {
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
    
    func validateCode(code: String){
        if(code.count == 6 && !code.contains(" ")){
            isValidCode = true
        } else {
            isValidCode = false
        }
    }
    
    // MARK: - DELEGATION
    
    @objc func joinSession(){
        print("join session")
        joinSessionCellDelegate.joinSession(textField: sessionTextField, isValidCode: isValidCode)
        
    }
    
}
