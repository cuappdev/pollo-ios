//
//  PollsCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn
import IGListKit
import Presentr
import UIKit

protocol PollsCellDelegate {
    
    func pollsCellShouldOpenSession(session: Session, userRole: UserRole)
    func pollsCellShouldEditSession(session: Session, userRole: UserRole)
    
}

class PollsCell: UICollectionViewCell {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    
    // MARK: - Data vars
    var delegate: PollsCellDelegate!
    var sessions: [Session] = []
    var pollType: PollType!
    
    let pollPreviewCellHeight: CGFloat = 82.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        GIDSignIn.sharedInstance().delegate = self
        setupViews()
    }
    
    func configureWith(pollType: PollType, delegate: PollsCellDelegate) {
        self.pollType = pollType
        self.delegate = delegate
        getPollSessions()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        contentView.addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    func getPollSessions() {
        let role: UserRole = pollType == .created ? .admin : .member
        GetPollSessions(role: String(describing: role)).make()
            .done { sessions in
                self.sessions = sessions
                self.adapter.performUpdates(animated: true, completion: nil)
            } .catch { error in
                print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
