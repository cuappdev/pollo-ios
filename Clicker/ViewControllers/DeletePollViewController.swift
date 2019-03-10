//
//  DeletePollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol DeletePollViewControllerDelegate: class {
    
    func deletePollViewControllerDidRemoveSession(for userRole: UserRole)
    
}

class DeletePollViewController: UIViewController {
    
    // MARK: - View vars
    var deleteLabel: UILabel!
    var cancelButton: UIButton!
    var deleteButton: UIButton!
    
    // MARK: - Data vars
    weak var delegate: DeletePollViewControllerDelegate?
    var session: Session!
    var userRole: UserRole!
    private let networking: Networking = URLSession.shared.request
    
    // MARK: - Constants
    let deleteLabelWidthScale: CGFloat = 0.9
    let deleteLabelTopPadding: CGFloat = 26
    let deleteLabelHeight: CGFloat = 40
    let cancelButtonLeftPadding: CGFloat = 16
    let cancelButtonHeight: CGFloat = 48
    let cancelButtonBottomPadding: CGFloat = 18
    let deleteButtonRightPadding: CGFloat = 16
    let buttonCenterYOffset: CGFloat = 9
    let navBarTitle = "Are you sure?"
    let adminDeleteLabelText = "Deleting will permanently close the group for all participants and all poll data will be lost."
    let memberDeleteLabelText = "Leaving will remove you from the group and you will no longer have access to its polls."
    let leaveDeletedPollErrorMessage = "Group may have been deleted. Try pulling to refresh."
    let adminDeleteButtonTitle = "Yes, Delete"
    let memberDeleteButtonTitle = "Yes, Leave"
    
    init(delegate: DeletePollViewControllerDelegate, session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.session = session
        self.userRole = userRole
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerWhite
        self.title = navBarTitle
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        deleteLabel = UILabel()
        deleteLabel.text = userRole == .admin ? adminDeleteLabelText : memberDeleteLabelText
        deleteLabel.textColor = .clickerGrey2
        deleteLabel.textAlignment = .center
        deleteLabel.font = UIFont._16RegularFont
        deleteLabel.numberOfLines = 0
        deleteLabel.lineBreakMode = .byWordWrapping
        view.addSubview(deleteLabel)
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .clickerGrey2
        cancelButton.layer.cornerRadius = 25
        cancelButton.addTarget(self, action: #selector(backCancelBtnPressed), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        deleteButton = UIButton()
        deleteButton.setTitle(userRole == .admin ? adminDeleteButtonTitle : memberDeleteButtonTitle, for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .clickerRed
        deleteButton.layer.cornerRadius = 25
        deleteButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        view.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        deleteLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(deleteLabelWidthScale)
            make.height.equalTo(deleteLabelHeight)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(deleteLabelTopPadding)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(cancelButtonLeftPadding)
            make.trailing.equalTo(view.snp.centerX).offset(buttonCenterYOffset * -1)
            make.height.equalTo(cancelButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(cancelButtonBottomPadding)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(deleteButtonRightPadding)
            make.leading.equalTo(view.snp.centerX).offset(buttonCenterYOffset)
            make.height.equalTo(cancelButton.snp.height)
            make.bottom.equalTo(cancelButton.snp.bottom)
        }
    }
    
    @objc func backCancelBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteSession(with id: Int) -> Future<DeleteResponse> {
        return networking(Endpoint.deleteSession(with: id)).decode()
    }
    
    func leaveSession(with id: Int) -> Future<DeleteResponse> {
        return networking(Endpoint.leaveSession(with: id)).decode()
    }
    
    @objc func deleteBtnPressed() {
        switch userRole! {
        case .admin:
            deleteSession(with: session.id).observe { [weak self] result in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        if response.success {
                            self.delegate?.deletePollViewControllerDidRemoveSession(for: self.userRole)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            let alertController = self.createAlert(title: "Error", message: "Failed to delete session. Try again!")
                            self.present(alertController, animated: true, completion: nil)
                        }
                    case .error(let error):
                        print(error)
                        let alertController = self.createAlert(title: "Error", message: "Failed to delete session. Try again!")
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        case .member:
            leaveSession(with: session.id).observe { [weak self] result in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        if response.success {
                            self.delegate?.deletePollViewControllerDidRemoveSession(for: self.userRole)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            let alertController = self.createAlert(title: "Error", message: self.leaveDeletedPollErrorMessage)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    case .error(let error):
                        print(error)
                        let alertController = self.createAlert(title: "Error", message: "Failed to leave session. Try again!")
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
