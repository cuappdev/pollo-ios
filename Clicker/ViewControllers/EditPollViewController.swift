//
//  EditPollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol EditPollViewControllerDelegate {
    
    func editPollViewControllerDidUpdateName(for userRole: UserRole)
    func editPollViewControllerDidDeleteSession(for userRole: UserRole)
    
}

class EditPollViewController: UIViewController {
    
    // MARK: - View vars
    var buttonStackView: UIStackView!
    var editView: UIView!
    var editNameImageView: UIImageView!
    var editNameButton: UIButton!
    var deleteView: UIView!
    var deleteImageView: UIImageView!
    var deleteButton: UIButton!
    
    // MARK: - Data vars
    var delegate: EditPollViewControllerDelegate!
    var session: Session!
    var userRole: UserRole!
    
    // MARK: - Constants
    let buttonStackViewHeight: CGFloat = 75
    let editViewHeight: CGFloat = 24
    let editNameImageViewLeftPadding: CGFloat = 18
    let editNameButtonLeftPadding: CGFloat = 18
    let editNameButtonWidthScaleFactor: CGFloat = 0.7
    let deleteImageViewLeftPadding: CGFloat = 18
    let deleteButtonLeftPadding: CGFloat = 18
    let deleteButtonWidthScaleFactor: CGFloat = 0.7
    let adminDeleteButtonTitle = "Delete"
    let memberDeleteButtonTitle = "Leave"
    
    init(delegate: EditPollViewControllerDelegate, session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.session = session
        self.userRole = userRole
    }
    
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
        editNameButton.contentHorizontalAlignment = .left
        editNameButton.titleLabel?.font = UIFont._16RegularFont
        editNameButton.addTarget(self, action: #selector(editNameBtnPressed), for: .touchUpInside)
        
        editView = UIView()
        editView.addSubview(editNameImageView)
        editView.addSubview(editNameButton)
        
        deleteImageView = UIImageView(image: #imageLiteral(resourceName: "delete"))
        
        deleteButton = UIButton()
        deleteButton.setTitle(userRole == .admin ? adminDeleteButtonTitle : memberDeleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(.clickerRed, for: .normal)
        deleteButton.contentHorizontalAlignment = .left
        deleteButton.titleLabel?.font = UIFont._16RegularFont
        deleteButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        
        deleteView = UIView()
        deleteView.addSubview(deleteImageView)
        deleteView.addSubview(deleteButton)
        
        let stackViewSubviews: [UIView] = userRole == .admin ? [editView, deleteView] : [deleteView]
        buttonStackView = UIStackView(arrangedSubviews: stackViewSubviews)
        buttonStackView.axis = .vertical
        buttonStackView.distribution =  .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        buttonStackView.snp.makeConstraints { make in
            if userRole == .admin {
                make.center.equalToSuperview()
            } else {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
            make.width.equalToSuperview()
            make.height.equalTo(buttonStackViewHeight)
        }
        
        if userRole == .admin {
            editView.snp.makeConstraints { make in
                make.height.equalTo(editViewHeight)
            }
            
            editNameImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(editNameImageViewLeftPadding)
                make.centerY.equalToSuperview()
            }
            
            editNameButton.snp.makeConstraints { make in
                make.left.equalTo(editNameImageView.snp.right).offset(editNameButtonLeftPadding)
                make.centerY.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(editNameButtonWidthScaleFactor)
            }
        }
        
        deleteView.snp.makeConstraints { make in
            make.height.equalTo(editViewHeight)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(deleteImageViewLeftPadding)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.left.equalTo(deleteImageView.snp.right).offset(deleteButtonLeftPadding)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(deleteButtonWidthScaleFactor)
        }
    }
    
    // MARK: ACTIONS
    
    @objc func deleteBtnPressed() {
        let deleteVC = DeletePollViewController(delegate: self, session: session, userRole: userRole)
        self.navigationController?.pushViewController(deleteVC, animated: true)
    }
    
    @objc func editNameBtnPressed() {
        let editNameVC = EditNameViewController(delegate: self, session: session)
        self.navigationController?.pushViewController(editNameVC, animated: true)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditPollViewController: EditNameViewControllerDelegate {
    
    func editNameViewControllerDidUpdateName() {
        self.delegate.editPollViewControllerDidUpdateName(for: userRole)
    }
    
}

extension EditPollViewController: DeletePollViewControllerDelegate {
    
    func deletePollViewControllerDidRemoveSession(for userRole: UserRole) {
        self.delegate.editPollViewControllerDidDeleteSession(for: userRole)
    }
    
}
