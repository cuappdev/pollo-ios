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
    var questionButton: UIButton!
    var timerLabel: UILabel!
    
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
    var timer: Timer!
    var elapsedSeconds: Int = 0
    
    // MARK: - Constants
    let shadowViewCornerRadius: CGFloat = 11.0
    let shadowHeightScaleFactor: CGFloat = 0.9
    let questionButtonFontSize: CGFloat = 16.0
    let questionButtonCornerRadius: CGFloat = 23.0
    let questionButtonBorderWidth: CGFloat = 1.0
    let questionButtonWidth: CGFloat = 170.0
    let questionButtonHeight: CGFloat = 47.0
    let questionButtonBottomPadding: CGFloat = 10.0
    let timerLabelFontSize: CGFloat = 14.0
    let timerLabelBottomPadding: CGFloat =  50.0
    let endQuestionText = "End Question"
    let shareResultsText = "Share Results"
    
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
        
        questionButton = UIButton()
        questionButton.titleLabel?.font = UIFont.systemFont(ofSize: questionButtonFontSize, weight: .semibold)
        questionButton.setTitleColor(.white, for: .normal)
        questionButton.layer.cornerRadius = questionButtonCornerRadius
        questionButton.layer.borderWidth = questionButtonBorderWidth
        questionButton.layer.borderColor = UIColor.white.cgColor
        questionButton.isHidden = true
        contentView.addSubview(questionButton)
        
        timerLabel = UILabel()
        timerLabel.font = UIFont.systemFont(ofSize: timerLabelFontSize, weight: .bold)
        timerLabel.textColor = .white
        timerLabel.isHidden = true
        contentView.addSubview(timerLabel)
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
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(timerLabelBottomPadding)
        }
        
        questionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(timerLabel.snp.top).offset(questionButtonBottomPadding * -1)
            make.width.equalTo(questionButtonWidth)
            make.height.equalTo(questionButtonHeight)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(with delegate: CardCellDelegate, poll: Poll) {
        self.delegate = delegate
        shadowViewWidth = delegate.cardControllerState == .vertical ? 15 : 0
        questionButton.isHidden = poll.state == .shared
        timerLabel.isHidden = !(poll.state == .live)
        if poll.state == .live {
            questionButton.setTitle(endQuestionText, for: .normal)
            runTimer()
        } else if poll.state == .ended {
            questionButton.setTitle(shareResultsText, for: .normal)
        }
        
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
    
    // MARK: - Helpers
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerLabel() {
        elapsedSeconds += 1
        if (elapsedSeconds < 10) {
            timerLabel.text = "00:0\(elapsedSeconds)"
        } else if (elapsedSeconds < 60) {
            timerLabel.text = "00:\(elapsedSeconds)"
        } else {
            let minutes = Int(elapsedSeconds / 60)
            let seconds = elapsedSeconds - minutes * 60
            if (elapsedSeconds < 600) {
                if (seconds < 10) {
                    timerLabel.text = "0\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "0\(minutes):\(seconds)"
                }
            } else {
                if (seconds < 10) {
                    timerLabel.text = "\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "\(minutes):\(seconds)"
                }
            }
        }
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
