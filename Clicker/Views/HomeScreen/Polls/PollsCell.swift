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

protocol PollsCellDelegate: class {
    
    func pollsCellDidPullToRefresh(for pollType: PollType)
    func pollsCellShouldEditSession(session: Session, userRole: UserRole)
    func pollsCellShouldOpenSession(session: Session, userRole: UserRole, withCell: PollPreviewCell)

}

class PollsCell: UICollectionViewCell {
    
    // MARK: - View vars
    var adapter: ListAdapter!
    var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    
    // MARK: - Data vars
    var pollTypeModel: PollTypeModel!
    weak var delegate: PollsCellDelegate?
    
    let pollPreviewCellHeight: CGFloat = 82.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func configureWith(pollTypeModel: PollTypeModel, delegate: PollsCellDelegate?) {
        self.pollTypeModel = pollTypeModel
        self.delegate = delegate
        self.adapter.performUpdates(animated: false, completion: nil)
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Updates
    func update(with sessions: [Session]) {
        pollTypeModel.sessions = sessions
        adapter.performUpdates(animated: false) { _ in
            self.refreshControl.endRefreshing()
        }
    }

    // MARK: - Actions
    @objc func pulledToRefresh() {
        delegate?.pollsCellDidPullToRefresh(for: pollTypeModel.pollType)
    }
}
