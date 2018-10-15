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
    func pollOptionsCellDidUpvoteChoice(choice: String)
    
}

class PollOptionsCell: UICollectionViewCell, UIScrollViewDelegate {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var arrowImageView: UIImageView!
    
    // MARK: - Data vars
    var delegate: PollOptionsCellDelegate!
    var adapter: ListAdapter!
    var pollOptionsModel: PollOptionsModel!
    var mcSelectedIndex: Int = NSNotFound
    
    // MARK: - Constants
    let contentViewCornerRadius: CGFloat = 12
    let interItemPadding: CGFloat = 5
    let maximumNumberVisibleOptions: Int = 6
    let arrowBottomInset: CGFloat = 9.8
    let arrowImageName: String = "DropdownArrowIcon"
    
        
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
        
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: arrowImageName)
        arrowImageView.isHidden = true
        contentView.addSubview(arrowImageView)
    }
    
    func updateArrowImageView(show: Bool) {
        UIView.animate(withDuration: 0.2) {
            if show {
                self.arrowImageView.alpha = 1
            } else {
                self.arrowImageView.alpha = 0
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !arrowImageView.isHidden {
            let diff = collectionView.contentSize.height - bounds.height - scrollView.contentOffset.y
            if diff < 10 {
                updateArrowImageView(show: false)
            } else {
                updateArrowImageView(show: true)
            }
        }
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        guard let pollOptionsModel = pollOptionsModel else { return }
        switch pollOptionsModel.type {
        case .mcResult(let mcResultModels):
            if mcResultModels.count > maximumNumberVisibleOptions {
                arrowImageView.isHidden = false
                arrowImageView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(arrowBottomInset)
                    make.centerX.equalToSuperview()
                }
            }
            break
        case .mcChoice(let mcChoiceModels):
            if mcChoiceModels.count > maximumNumberVisibleOptions {
                arrowImageView.isHidden = false
                arrowImageView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(arrowBottomInset)
                    make.centerX.equalToSuperview()
                }
            }
            break
        case .frOption(let frOptionModels):
            if frOptionModels.count > maximumNumberVisibleOptions {
                arrowImageView.isHidden = false
                arrowImageView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(arrowBottomInset)
                    make.centerX.equalToSuperview()
                }
            }
        }
        
        super.updateConstraints()
    }
    
    func configure(for pollOptionsModel: PollOptionsModel, delegate: PollOptionsCellDelegate) {
        self.pollOptionsModel = pollOptionsModel
        self.delegate = delegate
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PollOptionsCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var models = [ListDiffable]()
        let topSpaceModel = SpaceModel(space: LayoutConstants.pollOptionsPadding)
        let bottomSpaceModel = SpaceModel(space: LayoutConstants.pollOptionsPadding + interItemPadding)
        models.append(topSpaceModel)
        guard let pollOptionsModel = pollOptionsModel else { return [] }
        switch pollOptionsModel.type {
        case .mcResult(let mcResultModels):
            models.append(contentsOf: mcResultModels)
            break
        case .mcChoice(let mcChoiceModels):
            models.append(contentsOf: mcChoiceModels)
            break
        case .frOption(let frOptionModels):
            models.append(contentsOf: frOptionModels)
        }
        models.append(bottomSpaceModel)
        return models
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is MCResultModel {
            return MCResultSectionController(delegate: self)
        } else if object is MCChoiceModel {
            return MCChoiceSectionController(delegate: self)
        } else if object is FROptionModel {
            return FROptionSectionController(delegate: self)
        } else {
            return SpaceSectionController()
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
    
    func frOptionSectionControllerDidUpvote(sectionController: FROptionSectionController) {
        // Only members can upvote free responses
        if delegate.userRole == .admin || pollOptionsModel.pollState != .live { return }
        switch pollOptionsModel.type {
        case .frOption(optionModels: var frOptionModels):
            // Need to subtract 1 from index because topSpaceModel is the first section
            let upvoteIndex = adapter.section(for: sectionController) - 1
            let upvotedFROptionModel = frOptionModels[upvoteIndex]
            frOptionModels[upvoteIndex] = FROptionModel(option: upvotedFROptionModel.option, isAnswer: upvotedFROptionModel.isAnswer, numUpvoted: upvotedFROptionModel.numUpvoted + 1, didUpvote: true)
            pollOptionsModel.type = .frOption(optionModels: frOptionModels)
            adapter.performUpdates(animated: false, completion: nil)
            delegate.pollOptionsCellDidUpvoteChoice(choice: upvotedFROptionModel.option)
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
