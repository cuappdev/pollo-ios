//
//  DeletePollViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol DeletePollViewControllerDelegate {
    
    func deletePollViewControllerDidDeleteSession(for userRole: UserRole)
    
}

class DeletePollViewController: UIViewController {
    
    // MARK: - View vars
    var deleteLabel: UILabel!
    var cancelButton: UIButton!
    var deleteButton: UIButton!
    
    // MARK: - Data vars
    var delegate: DeletePollViewControllerDelegate!
    var session: Session!
    var userRole: UserRole!
    
    // MARK: - Constants
    let navBarTitle = "Are you sure?"
    let adminDeleteLabelText = "Deleting will permanently close the group for all participants and all poll data will be lost."
    let memberDeleteLabelText = "Leaving will remove you from the group and you will no longer have access to its polls."
    
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
        deleteButton.setTitle("Yes, Delete", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .clickerRed
        deleteButton.layer.cornerRadius = 25
        deleteButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        view.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        deleteLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.92)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(160)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(cancelButton.snp.width)
            make.height.equalTo(cancelButton.snp.height)
            make.bottom.equalTo(cancelButton.snp.bottom)
        }
    }
    
    @objc func backCancelBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteBtnPressed() {
        DeleteSession(id: session.id).make()
            .done {
                self.delegate.deletePollViewControllerDidDeleteSession(for: self.userRole)
                self.dismiss(animated: true, completion: nil)
            }.catch { error in
                print(error)
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
