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

class CardCell: UICollectionViewCell {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    
    // MARK: - Data vars
    var questionModel: QuestionModel!
    var resultModelArray: [MCResultModel]!
    var miscellaneousModel: PollMiscellaneousModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for poll: Poll) {
        questionModel = QuestionModel(question: poll.text)
        resultModelArray = []
        if let results = poll.results {
            for (_, info) in results {
                if let infoDict = info as? [String:Any] {
                    guard let option = infoDict["text"] as? String, let numSelected = infoDict["count"] as? Int else {
                        adapter.performUpdates(animated: true, completion: nil)
                        return
                    }
                    let resultModel = MCResultModel(option: option, numSelected: numSelected, percentSelected: 0.5)
                    resultModelArray.append(resultModel)
                }
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
        objects.append(questionModel)
        objects.append(contentsOf: resultModelArray)
        objects.append(miscellaneousModel)
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is QuestionModel {
            return QuestionSectionController()
        } else if object is MCResultModel {
            return MCResultSectionController()
        } else if object is PollMiscellaneousModel {
            
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
