//
//  DeletePollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class DeletePollViewController: UIViewController {
    
    var deleteLabel: UILabel!
    var cancelButton: UIButton!
    var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerWhite
        self.title = "Are you sure?"
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        deleteLabel = UILabel()
        deleteLabel.text = "Deleting will permanently close the group for all participants and all poll data will be lost."
        deleteLabel.font = UIFont._16RegularFont
        deleteLabel.numberOfLines = 0
        deleteLabel.lineBreakMode = .byWordWrapping
        view.addSubview(deleteLabel)
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .clickerMediumGray
        cancelButton.layer.cornerRadius = 25
        view.addSubview(cancelButton)
        
        deleteButton = UIButton()
        deleteButton.setTitle("Yes, Delete", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .clickerRed
        deleteButton.layer.cornerRadius = 25
        view.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        deleteLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.92)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(26)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(deleteLabel.snp.bottom).offset(26)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(160)
            make.height.equalTo(48)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.top)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(cancelButton.snp.width)
            make.height.equalTo(cancelButton.snp.height)
        }
    }
    
}
