//
//  PollOptionsCell.swift
//  Pollo
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

protocol PollOptionsCellDelegate: class {
    
    var userRole: UserRole { get }
    var isConnected: Bool { get }
    
    func pollOptionsCellDidSubmitChoice(choice: String, index: Int)
    
}

class PollOptionsCell: UICollectionViewCell, UIScrollViewDelegate {
    
    // MARK: - View vars
    var optionGradientView: OptionsGradientView!
    var collectionView: UICollectionView!
    
    // MARK: - Data vars
    var adapter: ListAdapter!
    var correctAnswer: String?
    var hasOverflowOptions: Bool = false
    var mcSelectedIndex: Int = NSNotFound
    var pollOptionsModel: PollOptionsModel!
    weak var delegate: PollOptionsCellDelegate!
    
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
        
        optionGradientView = OptionsGradientView(frame: frame)
        contentView.addSubview(optionGradientView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !optionGradientView.isHidden {
            let diff = collectionView.contentSize.height - bounds.height - scrollView.contentOffset.y
            optionGradientView.toggle(show: diff >= 10, animated: true)
        }
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        optionGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }

    // MARK: - Configure
    func configure(for pollOptionsModel: PollOptionsModel, delegate: PollOptionsCellDelegate, correctAnswer: String?) {
        self.pollOptionsModel = pollOptionsModel
        self.delegate = delegate
        self.correctAnswer = correctAnswer
        switch pollOptionsModel.type {
        case .mcResult(let mcResultModels):
            let maxOptions = delegate.userRole == .admin ? IntegerConstants.maxOptionsForAdminMC : IntegerConstants.maxOptionsForMemberMC
            hasOverflowOptions = mcResultModels.count > maxOptions
        case .mcChoice(let mcChoiceModels):
            let maxOptions = delegate.userRole == .admin ? IntegerConstants.maxOptionsForAdminMC : IntegerConstants.maxOptionsForMemberMC
            hasOverflowOptions = mcChoiceModels.count > maxOptions
            if let selectedIndex = mcChoiceModels.firstIndex(where: { (mcChoiceModel) -> Bool in
                return mcChoiceModel.isSelected
            }) {
                mcSelectedIndex = selectedIndex
            }
        }
        optionGradientView.isHidden = !hasOverflowOptions
        optionGradientView.gradientLayer.endPoint = CGPoint(x: 0.5, y: delegate.userRole == .admin ? 0 : 0.25)
        optionGradientView.toggle(show: !optionGradientView.isHidden, animated: false)
        collectionView.isScrollEnabled = hasOverflowOptions
        adapter.performUpdates(animated: false, completion: nil)
    }

    // MARK: - Update
    func update(with updatedPollOptionsModelType: PollOptionsModelType, correctAnswer: String?) {
        self.correctAnswer = correctAnswer
        switch updatedPollOptionsModelType {
        case .mcResult(resultModels: let updatedMCResultModels):
            switch pollOptionsModel.type {
            case .mcResult(resultModels: let mcResultModels):
                compare(oldMCResultModels: mcResultModels, updatedMCResultModels: updatedMCResultModels)
                self.pollOptionsModel.type = updatedPollOptionsModelType
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
                guard let sectionController = adapter.sectionController(forSection: index) as? MCResultSectionController else { return }
                sectionController.update(with: updatedMCResultModel)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PollOptionsCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let pollOptionsModel = pollOptionsModel else { return [] }
        var models = [ListDiffable]()
        let bottomSpaceModel = SpaceModel(space: LayoutConstants.pollOptionsBottomPadding, backgroundColor: .white)
        switch pollOptionsModel.type {
        case .mcResult(let mcResultModels):
            models.append(contentsOf: mcResultModels)
            models.append(bottomSpaceModel)
            return models
        case .mcChoice(let mcChoiceModels):
            models.append(contentsOf: mcChoiceModels)
            models.append(bottomSpaceModel)
            return models
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is MCResultModel {
            return MCResultSectionController(delegate: self, correctAnswer: correctAnswer)
        } else if object is MCChoiceModel {
            return MCChoiceSectionController(delegate: self)
        } else {
            guard let pollOptionsModel = pollOptionsModel else { return ListSectionController() }
            switch pollOptionsModel.type {
            case .mcResult, .mcChoice:
                return SpaceSectionController(noResponses: false)
            }
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PollOptionsCell: MCResultSectionControllerDelegate {
    
    var userRole: UserRole {
        return delegate.userRole
    }

    var isConnected: Bool {
        return delegate.isConnected
    }
    
}

extension PollOptionsCell: MCChoiceSectionControllerDelegate {
    
    var pollState: PollState {
        return pollOptionsModel.pollState
    }
    
    func mcChoiceSectionControllerWasSelected(sectionController: MCChoiceSectionController) {
        guard isConnected else { return }
        switch pollOptionsModel.type {
        case .mcChoice(choiceModels: var mcChoiceModels):
            if mcSelectedIndex != NSNotFound {
                // Deselect former choice
                mcChoiceModels[mcSelectedIndex] = updateMCChoiceModel(at: mcSelectedIndex, isSelected: false, mcChoiceModels: mcChoiceModels)
            }
            // Select new choice
            let selectedIndex = adapter.section(for: sectionController)
            let updatedMCChoiceModel = updateMCChoiceModel(at: selectedIndex, isSelected: true, mcChoiceModels: mcChoiceModels)
            mcChoiceModels[selectedIndex] = updatedMCChoiceModel
            pollOptionsModel.type = .mcChoice(choiceModels: mcChoiceModels)
            adapter.performUpdates(animated: false, completion: nil)
            mcSelectedIndex = selectedIndex
            delegate.pollOptionsCellDidSubmitChoice(choice: updatedMCChoiceModel.option, index: selectedIndex)
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
