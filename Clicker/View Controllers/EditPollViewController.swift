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
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        editNameImageView = UIImageView(image: #imageLiteral(resourceName: "editPoll"))
        
        editNameButton = UIButton()
        editNameButton.setTitle("Edit Name", for: .normal)
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
        
        buttonStackView = UIStackView(arrangedSubviews: [editView])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        view.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: session.name, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(exitBtnPressed))
    }
    
}
