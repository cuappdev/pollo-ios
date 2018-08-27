//
//  DeletePollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class EditNameViewController: UIViewController {
    
    var session: Session!
    var homeViewController: UIViewController!
    
    var nameTextField: UITextField!
    var saveButton: UIButton!
    
    let edgePadding = 18
    let textFieldHeight = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerWhite
        self.title = "Edit Name"
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        nameTextField = UITextField()
        nameTextField.placeholder = session.name
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
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
        if let newName = nameTextField.text {
            if (newName != "") {
                UpdateSession(id: session.id, name: newName, code: session.code).make()
                    .done { code in
                        if let pollsVC = self.homeViewController as? PollsViewController {
                            self.dismiss(animated: true, completion: nil)
                            for cell in pollsVC.pollsCollectionView.visibleCells {
                                if let pollsCell = cell as? PollsCell {
                                    DispatchQueue.main.async { pollsCell.getPollSessions() }
                                }
                            }
                        }
                    }.catch { error in
                        print("error: ", error)
                }
            }
        }
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
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.navigationController?.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.navigationController?.view.frame.origin.y += keyboardSize.height
        }
    }
    
}
