//
//  EditPollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class EditPollViewController: UIViewController {
    
    var session: Session!
    
    var buttonStackView: UIStackView!
    var editNameImageView: UIImageView!
    var editNameButton: UIButton!
    var deleteImageView: UIImageView!
    var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerWhite
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        editNameImageView = UIImageView(image: #imageLiteral(resourceName: "editPoll"))
        
        editNameButton = UIButton()
        editNameButton.setTitle("Edit Name", for: .normal)
        editNameButton.setTitleColor(.black, for: .normal)
        editNameButton.titleLabel?.font = UIFont._16RegularFont
        
        let editView = UIView()
        editView.addSubview(editNameImageView)
        editView.addSubview(editNameButton)
        
        deleteImageView = UIImageView(image: #imageLiteral(resourceName: "delete"))
        
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.clickerRed, for: .normal)
        deleteButton.titleLabel?.font = UIFont._16RegularFont
        
        let deleteView = UIView()
        deleteView.addSubview(deleteImageView)
        deleteView.addSubview(deleteButton)
        
        buttonStackView = UIStackView(arrangedSubviews: [editView, deleteView])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(80)
        }
        
        editNameImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        editNameButton.snp.makeConstraints { make in
            make.left.equalTo(editNameImageView.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.left.equalTo(editNameImageView.snp.right).offset(18)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func exitBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupNavBar() {
        let sessionNameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        sessionNameButton.setTitle(session.name, for: .normal)
        sessionNameButton.setTitleColor(.black, for: .normal)
        sessionNameButton.titleLabel?.font = UIFont._18SemiboldFont
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sessionNameButton)
        
        let exitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        exitButton.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitBtnPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton)
    }
    
}
