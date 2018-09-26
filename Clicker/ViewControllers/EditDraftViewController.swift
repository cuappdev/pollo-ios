//
//  EditDraftViewController.swift
//  Clicker
//
//  Created by Matthew Coufal on 9/25/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol EditDraftViewControllerDelegate {
    func editDraftViewControllerDidTapEditDraftButton(draft: Draft)
    func editDraftViewControllerDidTapDeleteDraftButton(draft: Draft)
}

class EditDraftViewController: UIViewController {

    // MARK: - View vars
    var editDraftButton: UIButton!
    var editDraftImageView: UIImageView!
    var editDraftLabel: UILabel!
    var deleteDraftButton: UIButton!
    var deleteDraftImageView: UIImageView!
    var deleteDraftLabel: UILabel!
    
    // MARK: - Data vars
    var delegate: EditDraftViewControllerDelegate!
    var draft: Draft!
    
    // MARK: - Constants
    let buttonHeight: CGFloat = 50
    let imageViewPadding: CGFloat = 18
    let editDraftLabelText: String = "Edit Draft"
    let deleteDraftLabelText: String = "Delete"
    
    init(delegate: EditDraftViewControllerDelegate, draft: Draft) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.draft = draft
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        editDraftButton = UIButton()
        editDraftButton.addTarget(self, action: #selector(editDraftButtonPressed), for: .touchUpInside)
        view.addSubview(editDraftButton)
        
        editDraftImageView = UIImageView()
        editDraftImageView.image = #imageLiteral(resourceName: "editPoll")
        view.addSubview(editDraftImageView)
        
        editDraftLabel = UILabel()
        editDraftLabel.text = editDraftLabelText
        editDraftLabel.textColor = .black
        editDraftLabel.font = UIFont._16RegularFont
        view.addSubview(editDraftLabel)
        
        deleteDraftButton = UIButton()
        deleteDraftButton.addTarget(self, action: #selector(deleteDraftButtonPressed), for: .touchUpInside)
        view.addSubview(deleteDraftButton)
        
        deleteDraftImageView = UIImageView()
        deleteDraftImageView.image = #imageLiteral(resourceName: "delete")
        view.addSubview(deleteDraftImageView)
        
        deleteDraftLabel = UILabel()
        deleteDraftLabel.text = deleteDraftLabelText
        deleteDraftLabel.textColor = .clickerRed
        deleteDraftLabel.font = editDraftLabel.font
        view.addSubview(deleteDraftLabel)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
        editDraftButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        editDraftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(imageViewPadding)
            make.centerY.equalTo(editDraftButton.snp.centerY)
        }
        
        editDraftLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-imageViewPadding * 2)
            make.height.equalTo(editDraftButton.snp.height)
            make.left.equalTo(editDraftImageView.snp.right).offset(imageViewPadding)
        }
        
        deleteDraftButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(editDraftButton.snp.height)
            make.top.equalTo(editDraftButton.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        deleteDraftImageView.snp.makeConstraints { make in
            make.left.equalTo(editDraftImageView.snp.left)
            make.centerY.equalTo(deleteDraftButton.snp.centerY)
        }
        
        deleteDraftLabel.snp.makeConstraints { make in
            make.width.equalTo(editDraftLabel.snp.width)
            make.height.equalTo(editDraftLabel.snp.height)
            make.left.equalTo(editDraftLabel.snp.left)
            make.centerY.equalTo(deleteDraftButton.snp.centerY)
        }
        
    }
    
    @objc func editDraftButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        delegate.editDraftViewControllerDidTapEditDraftButton(draft: draft)
    }
    
    @objc func deleteDraftButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        delegate.editDraftViewControllerDidTapDeleteDraftButton(draft: draft)
    }

}
