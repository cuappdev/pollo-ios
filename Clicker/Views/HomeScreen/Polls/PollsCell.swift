//
//  PollsCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn
import Presentr
import UIKit

protocol PollsCellDelegate {
    func shouldEditSession(session: Session)
    func shouldPushCardController(cardController: CardController)
}

class PollsCell: UICollectionViewCell {
    
    var pollsTableView: UITableView!
    
    var delegate: PollsCellDelegate!
    var sessions: [Session] = []
    var pollType: PollType!
    
    let pollPreviewCellHeight: CGFloat = 82.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        GIDSignIn.sharedInstance().delegate = self
        getPollSessions()
        setupViews()
        setupConstraints()
    }
    
    func configureWith(pollType: PollType, delegate: PollsCellDelegate) {
        self.pollType = pollType
        self.delegate = delegate
        
        getPollSessions()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        pollsTableView = UITableView()
        pollsTableView.delegate = self
        pollsTableView.dataSource = self
        pollsTableView.register(PollPreviewCell.self, forCellReuseIdentifier: Identifiers.pollPreviewIdentifier)
        pollsTableView.separatorStyle = .none
        addSubview(pollsTableView)
    }
    
    func setupConstraints() {
        pollsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getPollSessions() {
        if (User.userSession == nil) { return }
        let role: UserRole
        if (pollType == .created) {
            role = .admin
        } else {
            role = .member
        }
        GetPollSessions(role: String(describing: role)).make()
            .done { sessions in
                self.sessions = sessions
                DispatchQueue.main.async { self.pollsTableView.reloadData() }
            } .catch { error in
                print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
