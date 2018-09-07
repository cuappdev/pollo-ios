//
//  PollOptionsCell.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

protocol PollOptionsCellDelegate {
    var cardControllerState: CardControllerState { get }
}

class PollOptionsCell: UICollectionViewCell {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    
    // MARK: - Data vars
    var delegate: PollOptionsCellDelegate!
    var adapter: ListAdapter!
    var pollOptionsModel: PollOptionsModel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(LayoutConstants.pollOptionsVerticalPadding)
            make.bottom.equalToSuperview().inset(LayoutConstants.pollOptionsVerticalPadding)
        }
        super.updateConstraints()
    }
    
    func configure(for pollOptionsModel: PollOptionsModel, delegate: PollOptionsCellDelegate) {
        self.pollOptionsModel = pollOptionsModel
        self.delegate = delegate
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PollOptionsCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let pollOptionsModel = pollOptionsModel else { return [] }
        if let multipleChoiceResultModels = pollOptionsModel.mcResultModels {
            return multipleChoiceResultModels
        }
        return []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return MCResultSectionController(delegate: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PollOptionsCell: MCResultSectionControllerDelegate {
    
    var cardControllerState: CardControllerState {
        return delegate.cardControllerState
    }
    
}
