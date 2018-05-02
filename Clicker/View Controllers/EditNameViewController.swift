//
//  DeletePollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class EditNameViewController: UIViewController {
    
    var sessionName: String!
    var nameTextField: UITextField!
    var saveButton: UIButton!
    
    let edgePadding = 18
    let textFieldHeight = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerWhite
        self.title = "Edit Name"
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        nameTextField = UITextField()
        nameTextField.placeholder = sessionName
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.clickerBorder.cgColor
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: edgePadding, height: textFieldHeight))
        nameTextField.leftViewMode = .always
        view.addSubview(nameTextField)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .clickerBlue
        saveButton.layer.cornerRadius = 25
        saveButton.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        view.addSubview(saveButton)
        
    }
    
    func setupConstraints() {
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(26)
            make.width.equalToSuperview().multipliedBy(0.92)
            make.height.equalTo(textFieldHeight)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-16)
        }

    }
    
    @objc func saveBtnPressed() {
        // TODO: SAVE NEW NAME
        print("save name")
    }
    
    @objc func backCancelBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func exitBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupNavBar() {
        let backImage = UIImage(named: "blackBack")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(backCancelBtnPressed))
        
        let exitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        exitButton.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitBtnPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton)
    }
    
}
