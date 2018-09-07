//
//  DateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SnapKit
import SwiftyJSON
import UIKit

protocol CardCellDelegate {
    var cardControllerState: CardControllerState { get }
}

class CardCell: UICollectionViewCell {
    
    // MARK: - View vars
    var shadowView: UIView!
    var collectionView: UICollectionView!
    
    // MARK: - Data vars
    var delegate: CardCellDelegate!
    var adapter: ListAdapter!
    var topHamburgerCardModel: HamburgerCardModel!
    var questionModel: QuestionModel!
    var separatorLineModel: SeparatorLineModel!
    var resultModelArray: [MCResultModel]!
    var miscellaneousModel: PollMiscellaneousModel!
    var pollButtonModel: PollButtonModel!
    var bottomHamburgerCardModel: HamburgerCardModel!
    var shadowViewWidth: CGFloat!
    
    // MARK: - Constants
    let shadowViewCornerRadius: CGFloat = 11
    let shadowHeightScaleFactor: CGFloat = 0.9
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topHamburgerCardModel = HamburgerCardModel(state: .top)
        separatorLineModel = SeparatorLineModel()
        pollButtonModel = PollButtonModel(state: .ended)
        bottomHamburgerCardModel = HamburgerCardModel(state: .bottom)
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
        
        shadowView = UIView()
        shadowView.backgroundColor = .clickerGrey3
        shadowView.layer.cornerRadius = shadowViewCornerRadius
        shadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        contentView.addSubview(shadowView)
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(shadowViewWidth)
        }
        
        shadowView.snp.updateConstraints { make in
            make.leading.equalTo(collectionView.snp.trailing)
            make.trailing.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(shadowHeightScaleFactor)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(with delegate: CardCellDelegate, poll: Poll) {
        self.delegate = delegate
        shadowViewWidth = delegate.cardControllerState == .vertical ? 15 : 0
        questionModel = QuestionModel(question: poll.text)
        resultModelArray = []
        let totalNumResults = poll.getTotalResults()
        for (_, info) in poll.results {
            if let infoDict = info as? [String:Any] {
                guard let option = infoDict["text"] as? String, let numSelected = infoDict["count"] as? Int else { return }
                let percentSelected = totalNumResults > 0 ? Float(numSelected) / totalNumResults : 0
                let resultModel = MCResultModel(option: option, numSelected: Int(numSelected), percentSelected: percentSelected)
                resultModelArray.append(resultModel)
            }
        }
        
        miscellaneousModel = PollMiscellaneousModel(pollState: .ended, totalVotes: 32)
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let questionModel = questionModel, let resultModelArray = resultModelArray, let miscellaneousModel = miscellaneousModel else { return [] }
        var objects: [ListDiffable] = []
        objects.append(topHamburgerCardModel)
        objects.append(questionModel)
        objects.append(miscellaneousModel)
        objects.append(separatorLineModel)
        objects.append(contentsOf: resultModelArray)
        objects.append(pollButtonModel)
        objects.append(bottomHamburgerCardModel)
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is QuestionModel {
            return QuestionSectionController()
        } else if object is MCResultModel {
            return MCResultSectionController()
        } else if object is PollMiscellaneousModel {
            return PollMiscellaneousSectionController()
        } else if object is PollButtonModel {
            return PollButtonSectionController()
        } else if object is HamburgerCardModel {
            return HamburgerCardSectionController()
        } else {
            return SeparatorLineSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
