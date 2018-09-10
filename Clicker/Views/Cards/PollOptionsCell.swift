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
    var userRole: UserRole { get }
}

class PollOptionsCell: UICollectionViewCell {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    
    // MARK: - Data vars
    var delegate: PollOptionsCellDelegate!
    var adapter: ListAdapter!
    var pollOptionsModel: PollOptionsModel!
    var mcSelectedIndex: Int = NSNotFound
        
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
        switch pollOptionsModel.type {
        case .mcResult(resultModels: let mcResultModels):
            return mcResultModels
        case .mcChoice(choiceModels: let mcChoiceModels):
            return mcChoiceModels
        case .frOption(optionModels: let frOptionModels):
            return frOptionModels
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is MCResultModel {
            return MCResultSectionController(delegate: self)
        } else if object is MCChoiceModel {
            return MCChoiceSectionController(delegate: self)
        } else {
            return FROptionSectionController(delegate: self)
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PollOptionsCell: MCResultSectionControllerDelegate, FROptionSectionControllerDelegate {
    
    var cardControllerState: CardControllerState {
        return delegate.cardControllerState
    }
    
    var userRole: UserRole {
        return delegate.userRole
    }
    
    func frOptionSectionControllerDidUpvote(sectionController: FROptionSectionController) {
        switch pollOptionsModel.type {
        case .frOption(optionModels: var frOptionModels):
            let upvoteIndex = adapter.section(for: sectionController)
            let upvotedFROptionModel = frOptionModels[upvoteIndex]
            frOptionModels[upvoteIndex] = FROptionModel(option: upvotedFROptionModel.option, isAnswer: upvotedFROptionModel.isAnswer, numUpvoted: upvotedFROptionModel.numUpvoted + 1, didUpvote: true)
            pollOptionsModel.type = .frOption(optionModels: frOptionModels)
            adapter.performUpdates(animated: false, completion: nil)
        default:
            return
        }
    }
    
}

extension PollOptionsCell: MCChoiceSectionControllerDelegate {
    
    var pollState: PollState {
        return pollOptionsModel.pollState
    }
    
    func mcChoiceSectionControllerWasSelected(sectionController: MCChoiceSectionController) {
        if mcSelectedIndex != NSNotFound {
            switch pollOptionsModel.type {
            case .mcChoice(choiceModels: var mcChoiceModels):
                let currentChoiceModel = mcChoiceModels[mcSelectedIndex]
                mcChoiceModels[mcSelectedIndex] = MCChoiceModel(option: currentChoiceModel.option, isSelected: false)
                pollOptionsModel.type = .mcChoice(choiceModels: mcChoiceModels)
                adapter.performUpdates(animated: false, completion: nil)
            default:
                return
            }
        }
        mcSelectedIndex = adapter.section(for: sectionController)
    }
    
}
