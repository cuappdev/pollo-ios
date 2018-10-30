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
    
    var userRole: UserRole { get }
    
    func pollOptionsCellDidSubmitChoice(choice: String)
    func pollOptionsCellDidUpvote(for answerId: String)
    
}

class PollOptionsCell: UICollectionViewCell, UIScrollViewDelegate {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var arrowView: ArrowView!
    
    // MARK: - Data vars
    var delegate: PollOptionsCellDelegate!
    var adapter: ListAdapter!
    var pollOptionsModel: PollOptionsModel!
    var mcSelectedIndex: Int = NSNotFound
    var hasOverflowOptions: Bool = false
    
    // MARK: - Constants
    let contentViewCornerRadius: CGFloat = 12
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentView.layer.cornerRadius = contentViewCornerRadius
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        arrowView = ArrowView()
        contentView.addSubview(arrowView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !arrowView.isHidden {
            let diff = collectionView.contentSize.height - bounds.height - scrollView.contentOffset.y
            if diff < 10 {
                arrowView.toggle(show: false, animated: true)
            } else {
                arrowView.toggle(show: true, animated: true)
            }
        }
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        super.updateConstraints()
    }

    // MARK: - Configure
    func configure(for pollOptionsModel: PollOptionsModel, delegate: PollOptionsCellDelegate) {
        self.pollOptionsModel = pollOptionsModel
        self.delegate = delegate
        switch pollOptionsModel.type {
        case .mcResult(let mcResultModels):
            let maxOptions = delegate.userRole == .admin ? IntegerConstants.maxOptionsForAdminMC : IntegerConstants.maxOptionsForMemberMC
            hasOverflowOptions = mcResultModels.count > maxOptions
            break
        case .mcChoice(let mcChoiceModels):
            let maxOptions = delegate.userRole == .admin ? IntegerConstants.maxOptionsForAdminMC : IntegerConstants.maxOptionsForMemberMC
            hasOverflowOptions = mcChoiceModels.count > maxOptions
            if let selectedIndex = mcChoiceModels.firstIndex(where: { (mcChoiceModel) -> Bool in
                return mcChoiceModel.isSelected
            }) {
                mcSelectedIndex = selectedIndex
            }
            break
        case .frOption(let frOptionModels):
            let maxOptions = delegate.userRole == .admin ? IntegerConstants.maxOptionsForAdminFR : IntegerConstants.maxOptionsForMemberFR
            hasOverflowOptions = frOptionModels.count > maxOptions
        }
        arrowView.isHidden = !hasOverflowOptions
        arrowView.toggle(show: !arrowView.isHidden, animated: false)
        collectionView.isScrollEnabled = hasOverflowOptions
        adapter.performUpdates(animated: false, completion: nil)
    }

    // MARK: - Update
    func update(with updatedPollOptionsModelType: PollOptionsModelType) {
        switch updatedPollOptionsModelType {
        case .mcResult(resultModels: let updatedMCResultModels):
            switch pollOptionsModel.type {
            case .mcResult(resultModels: let mcResultModels):
                compare(oldMCResultModels: mcResultModels, updatedMCResultModels: updatedMCResultModels)
                self.pollOptionsModel.type = updatedPollOptionsModelType
            default:
                return
            }
        case .frOption(optionModels: let updatedFROptionModels):
            switch pollOptionsModel.type {
            case .frOption(optionModels: var frOptionModels):
                let combinedFROptionModels = combine(oldFROptionModels: frOptionModels, updatedFROptionModels: updatedFROptionModels)
                pollOptionsModel.type = .frOption(optionModels: combinedFROptionModels)
                adapter.performUpdates(animated: false, completion: nil)
            default:
                return
            }
        default:
            return
        }
    }

    // MARK: - Helpers
    func compare(oldMCResultModels: [MCResultModel], updatedMCResultModels: [MCResultModel]) {
        if updatedMCResultModels.count != oldMCResultModels.count { return }
        for index in 0..<updatedMCResultModels.count {
            let updatedMCResultModel = updatedMCResultModels[index]
            let mcResultModel = oldMCResultModels[index]
            if !mcResultModel.isEqual(toUpdatedModel: updatedMCResultModel) {
                // Have to do index + 1 because first model is SpaceModel
                guard let sectionController = adapter.sectionController(forSection: index + 1) as? MCResultSectionController else { return }
                sectionController.update(with: updatedMCResultModel)
            }
        }
    }

    func combine(oldFROptionModels: [FROptionModel], updatedFROptionModels: [FROptionModel]) -> [FROptionModel] {
        var frOptionModels: [FROptionModel] = oldFROptionModels
        updatedFROptionModels.forEach { (updatedFROptionModel) in
            if let index = frOptionModels.firstIndex(where: { (frOptionModel) -> Bool in
                return updatedFROptionModel.answerId == frOptionModel.answerId
            }) {
                // Don't have to do index + 1 because FR does not have topSpaceModel
                guard let sectionController = adapter.sectionController(forSection: index) as? FROptionSectionController else { return }
                sectionController.update(with: updatedFROptionModel)
                frOptionModels[index].numUpvoted = updatedFROptionModel.numUpvoted
                frOptionModels[index].didUpvote = updatedFROptionModel.didUpvote
            } else {
                frOptionModels.insert(updatedFROptionModel, at: 0)
            }
        }
        frOptionModels.sort { (frOptionModelA, frOptionModelB) -> Bool in
            return frOptionModelA.numUpvoted > frOptionModelB.numUpvoted
        }
        return frOptionModels
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PollOptionsCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let pollOptionsModel = pollOptionsModel else { return [] }
        var models = [ListDiffable]()
        let topSpaceModel = SpaceModel(space: LayoutConstants.pollOptionsPadding)
        let bottomSpaceModel = SpaceModel(space: LayoutConstants.pollOptionsPadding + LayoutConstants.interItemPadding)
        switch pollOptionsModel.type {
        case .mcResult(let mcResultModels):
            models.append(topSpaceModel)
            models.append(contentsOf: mcResultModels)
            models.append(bottomSpaceModel)
            return models
        case .mcChoice(let mcChoiceModels):
            models.append(topSpaceModel)
            models.append(contentsOf: mcChoiceModels)
            models.append(bottomSpaceModel)
            return models
        case .frOption(let frOptionModels):
            if !frOptionModels.isEmpty {
                models.append(contentsOf: frOptionModels)
                models.append(bottomSpaceModel)
            } else {
                let noResponsesModel = SpaceModel(space: LayoutConstants.noResponsesSpace)
                models.append(noResponsesModel)
            }
            return models
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is MCResultModel {
            return MCResultSectionController(delegate: self)
        } else if object is MCChoiceModel {
            return MCChoiceSectionController(delegate: self)
        } else if object is FROptionModel {
            return FROptionSectionController(delegate: self)
        } else {
            guard let pollOptionsModel = pollOptionsModel else { return ListSectionController() }
            switch pollOptionsModel.type {
            case .mcResult(_):
                return SpaceSectionController(noResponses: false)
            case .mcChoice(_):
                return SpaceSectionController(noResponses: false)
            case .frOption(let models):
                return SpaceSectionController(noResponses: models.isEmpty)
            }
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PollOptionsCell: MCResultSectionControllerDelegate, FROptionSectionControllerDelegate {
    
    var userRole: UserRole {
        return delegate.userRole
    }

    func frOptionSectionControllerDidUpvote(for answerId: String) {
        // Only members can upvote free responses
        if delegate.userRole == .admin || pollOptionsModel.pollState != .live { return }
        delegate.pollOptionsCellDidUpvote(for: answerId)
    }
    
}

extension PollOptionsCell: MCChoiceSectionControllerDelegate {
    
    var pollState: PollState {
        return pollOptionsModel.pollState
    }
    
    func mcChoiceSectionControllerWasSelected(sectionController: MCChoiceSectionController) {
        switch pollOptionsModel.type {
        case .mcChoice(choiceModels: var mcChoiceModels):
            if (mcSelectedIndex != NSNotFound) {
                // Deselect former choice
                mcChoiceModels[mcSelectedIndex] = updateMCChoiceModel(at: mcSelectedIndex, isSelected: false, mcChoiceModels: mcChoiceModels)
            }
            // Select new choice
            // Need to subtract 1 from index because topSpaceModel is the first section
            let selectedIndex = adapter.section(for: sectionController) - 1
            let updatedMCChoiceModel = updateMCChoiceModel(at: selectedIndex, isSelected: true, mcChoiceModels: mcChoiceModels)
            mcChoiceModels[selectedIndex] = updatedMCChoiceModel
            pollOptionsModel.type = .mcChoice(choiceModels: mcChoiceModels)
            adapter.performUpdates(animated: false, completion: nil)
            mcSelectedIndex = selectedIndex
            delegate.pollOptionsCellDidSubmitChoice(choice: updatedMCChoiceModel.option)
        default:
            return
        }
    }
    
    // MARK: - Helpers
    private func updateMCChoiceModel(at index: Int, isSelected: Bool, mcChoiceModels: [MCChoiceModel]) -> MCChoiceModel {
        let choiceModel = mcChoiceModels[index]
        return MCChoiceModel(option: choiceModel.option, isSelected: isSelected)
    }
    
}
