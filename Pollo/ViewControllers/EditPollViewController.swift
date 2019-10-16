//
//  EditPollViewController.swift
//  Pollo
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol EditPollViewControllerDelegate: class {
    
    func editPollViewControllerDidUpdateName(for userRole: UserRole)
    func editPollViewControllerDidDeleteSession(for userRole: UserRole)
    func editPollViewControllerDidDeletePoll(sender: EditPollViewController)
    func editPollViewControllerDidReopenPoll(sender: EditPollViewController)

}

enum EditType {
    case poll, session
}

class EditPollViewController: UIViewController {
    
    // MARK: - View vars
    var buttonStackView: UIStackView!
    var editView: UIView!
    var editNameImageButton: UIButton!
    var editNameButton: UIButton!
    var deleteView: UIView!
    var deleteImageButton: UIButton!
    var deleteButton: UIButton!
    var reopenButton: UIButton!
    var reopenView: UIView!
    
    // MARK: - Data vars
    weak var delegate: EditPollViewControllerDelegate?
    var session: Session!
    var userRole: UserRole!
    var editType: EditType!
    var countLabelText: String?
    
    // MARK: - Constants
    let buttonStackViewAdminTopOffset: CGFloat = 20
    let editViewHeight: CGFloat = 20
    let editNameImageButtonLeftPadding: CGFloat = 18
    let editNameButtonLeftPadding: CGFloat = 18
    let editNameButtonWidthScaleFactor: CGFloat = 0.7
    let deleteImageButtonLeftPadding: CGFloat = 18
    let deleteButtonLeftPadding: CGFloat = 18
    let deleteButtonWidthScaleFactor: CGFloat = 0.7
    let reopenButtonLeadingPadding: CGFloat = 18
    let reopenButtonWidthScaleFactor: CGFloat = 0.7
    let stackViewHeight: CGFloat = 40
    let adminDeleteButtonTitle = "Delete"
    let memberDeleteButtonTitle = "Leave"
    let editNameButtonTitle = "Edit Name"
    let reopenButtonTitle = "Reopen"
    let deleteImageName = "delete"
    let leaveImageName = "door"
    let editImageName = "editPoll"

    init(_ type: EditType, delegate: EditPollViewControllerDelegate, session: Session, userRole: UserRole, countLabelText: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.editType = type
        self.delegate = delegate
        self.session = session
        self.userRole = userRole
        self.countLabelText = countLabelText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerWhite
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        editNameImageButton = UIButton()
        editNameImageButton.setImage(UIImage(named: editImageName), for: .normal)
        editNameImageButton.addTarget(self, action: #selector(editNameBtnPressed), for: .touchUpInside)
        
        editNameButton = UIButton()
        editNameButton.setTitle(editNameButtonTitle, for: .normal)
        editNameButton.setTitleColor(.black, for: .normal)
        editNameButton.contentHorizontalAlignment = .left
        editNameButton.titleLabel?.font = ._16RegularFont
        editNameButton.addTarget(self, action: #selector(editNameBtnPressed), for: .touchUpInside)
        
        editView = UIView()
        editView.addSubview(editNameImageButton)
        editView.addSubview(editNameButton)
        
        deleteImageButton = UIButton()
        deleteImageButton.setImage(userRole == .admin ? UIImage(named: deleteImageName) : UIImage(named: leaveImageName), for: .normal)
        deleteImageButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        
        deleteButton = UIButton()
        deleteButton.setTitle(userRole == .admin ? adminDeleteButtonTitle : memberDeleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(.clickerRed, for: .normal)
        deleteButton.contentHorizontalAlignment = .left
        deleteButton.titleLabel?.font = ._16RegularFont
        deleteButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        
        deleteView = UIView()
        deleteView.addSubview(deleteImageButton)
        deleteView.addSubview(deleteButton)

        reopenButton = UIButton()
        reopenButton.setTitle(reopenButtonTitle, for: .normal)
        reopenButton.setTitleColor(.black, for: .normal)
        reopenButton.contentHorizontalAlignment = .leading
        reopenButton.titleLabel?.font = ._16RegularFont
        reopenButton.addTarget(self, action: #selector(reopenBtnPressed), for: .touchUpInside)

        reopenView = UIView()
        reopenView.addSubview(reopenButton)

        var stackViewSubviews: [UIView] = []
        switch editType! {
        case .session:
            stackViewSubviews = userRole == .admin ? [editView, deleteView] : [deleteView]
        case .poll:
            stackViewSubviews = [deleteView]
        }
        
        buttonStackView = UIStackView(arrangedSubviews: stackViewSubviews)
        buttonStackView.axis = .vertical
        buttonStackView.distribution =  .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        let buttonStackViewTopOffset = userRole == .admin ? buttonStackViewAdminTopOffset : 0
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(buttonStackViewTopOffset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(stackViewHeight)
        }
        
        if userRole == .admin, editType == .session {
            editView.snp.makeConstraints { make in
                make.height.equalTo(editViewHeight)
            }
            
            editNameImageButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(editNameImageButtonLeftPadding)
                make.centerY.equalToSuperview()
            }
            
            editNameButton.snp.makeConstraints { make in
                make.left.equalTo(editNameImageButton.snp.right).offset(editNameButtonLeftPadding)
                make.centerY.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(editNameButtonWidthScaleFactor)
            }
        } else {
            reopenButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(reopenButtonLeadingPadding)
                make.centerY.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(reopenButtonWidthScaleFactor)
            }
        }

        deleteView.snp.makeConstraints { make in
            make.height.equalTo(editViewHeight)
            make.leading.trailing.equalToSuperview()
        }

        deleteImageButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(deleteImageButtonLeftPadding)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.left.equalTo(deleteImageButton.snp.right).offset(deleteButtonLeftPadding)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(deleteButtonWidthScaleFactor)
        }

    }
    
    // MARK: ACTIONS
    
    @objc func deleteBtnPressed() {
        switch editType! {
        case .poll:
            delegate?.editPollViewControllerDidDeletePoll(sender: self)
        case .session:
            let deleteVC = DeletePollViewController(delegate: self, session: session, userRole: userRole)
            self.navigationController?.pushViewController(deleteVC, animated: true)
        }
    }
    
    @objc func editNameBtnPressed() {
        let editNameVC = EditNameViewController(delegate: self, session: session)
        self.navigationController?.pushViewController(editNameVC, animated: true)
    }
    
    @objc func exitBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func reopenBtnPressed() {
        delegate?.editPollViewControllerDidReopenPoll(sender: self)
    }
    
    func setupNavBar() {
        let sessionNameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        sessionNameButton.setTitleColor(.black, for: .normal)
        sessionNameButton.titleLabel?.font = ._18SemiboldFont
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sessionNameButton)
        
        let exitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        exitButton.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitBtnPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton)

        switch editType! {
        case .poll:
            guard let count = countLabelText else { return }
            sessionNameButton.setTitle("Question: \(count)", for: .normal)
        case .session:
            sessionNameButton.setTitle(session.name, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch editType! {
        case .poll:
            return .lightContent
        case .session:
            return .default
        }
    }
    
}

extension EditPollViewController: EditNameViewControllerDelegate {
    
    func editNameViewControllerDidUpdateName() {
        self.delegate?.editPollViewControllerDidUpdateName(for: userRole)
    }
    
}

extension EditPollViewController: DeletePollViewControllerDelegate {
    
    func deletePollViewControllerDidRemoveSession(for userRole: UserRole) {
        self.delegate?.editPollViewControllerDidDeleteSession(for: userRole)
    }
    
}
