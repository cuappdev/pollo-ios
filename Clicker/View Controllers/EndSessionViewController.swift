//
//  EndSessionViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class EndSessionViewController: UIViewController {
    
    var cancelButton: UIButton!
    var confirmationLabel: UILabel!
    var sidenoteLabel: UILabel!
    var sessionView: UIView!
    var nameSessionTextField: UITextField!
    var saveButton: UIButton!
    var endSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.clickerGreen, for: .normal)
        cancelButton.titleLabel?.font = UIFont._16SemiboldFont
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        confirmationLabel = UILabel()
        confirmationLabel.text = "Are you sure you want to end session?"
        confirmationLabel.textColor = .clickerBlack
        confirmationLabel.font = UIFont._18SemiboldFont
        view.addSubview(confirmationLabel)
        
        sidenoteLabel = UILabel()
        sidenoteLabel.text = "This will close any open polls and cause any remaining participants to exit."
        sidenoteLabel.textColor = .clickerBlack
        sidenoteLabel.font = UIFont.systemFont(ofSize: 12)
        sidenoteLabel.lineBreakMode = .byWordWrapping
        sidenoteLabel.numberOfLines = 0
        view.addSubview(sidenoteLabel)
        
        sessionView = UIView()
        sessionView.backgroundColor = .clickerBackground
        sessionView.layer.cornerRadius = 8
        sessionView.layer.borderColor = UIColor(red: 232/255, green: 233/255, blue: 236/255, alpha: 1.0).cgColor
        sessionView.layer.borderWidth = 0.5
        view.addSubview(sessionView)
        
        saveButton = UIButton()
        saveButton.setImage(#imageLiteral(resourceName: "save"), for: .normal)
        saveButton.backgroundColor = .clear
        sessionView.addSubview(saveButton)
        
        nameSessionTextField = UITextField()
        nameSessionTextField.placeholder = "Enter a name to save this session"
        nameSessionTextField.font = UIFont._16RegularFont
        nameSessionTextField.borderStyle = .none
        nameSessionTextField.backgroundColor = .clear
        nameSessionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        sessionView.addSubview(nameSessionTextField)
        
        endSessionButton = UIButton()
        endSessionButton.setTitle("Yes, end session", for: .normal)
        endSessionButton.setTitleColor(.white, for: .normal)
        endSessionButton.backgroundColor = .clickerOrange
        endSessionButton.layer.cornerRadius = 8
        view.addSubview(endSessionButton)
    }
    
    func setupConstraints() {
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 20))
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(18)
        }
        
        confirmationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.height.equalTo(24)
            make.top.equalTo(cancelButton.snp.bottom).offset(24)
        }
        
        sidenoteLabel.snp.makeConstraints { make in
            make.width.equalTo(confirmationLabel.snp.width)
            make.height.equalTo(32)
            make.top.equalTo(confirmationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        sessionView.snp.makeConstraints { make in
            make.width.equalTo(confirmationLabel.snp.width)
            make.height.equalTo(55)
            make.top.equalTo(sidenoteLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        nameSessionTextField.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(saveButton.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        endSessionButton.snp.makeConstraints { make in
            make.width.equalTo(confirmationLabel.snp.width)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().offset(-17.5)
            make.centerX.equalToSuperview()
        }
    }
}
