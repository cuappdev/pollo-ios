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
    var userRole: UserRole { get }
    
    func cardCellDidSubmitChoice(cardCell: CardCell, choice: String)
    func cardCellDidUpvoteChoice(cardCell: CardCell, choice: String)
    func cardCellDidEndPoll(cardCell: CardCell, poll: Poll)
    func cardCellDidShareResults(cardCell: CardCell, poll: Poll)
}

class CardCell: UICollectionViewCell {
    
    // MARK: - View vars
    var shadowView: UIView!
    var collectionView: UICollectionView!
    var questionButton: UIButton!
    var timerLabel: UILabel!
    
    // MARK: - Data vars
    var delegate: CardCellDelegate!
    var poll: Poll!
    var adapter: ListAdapter!
    var topHamburgerCardModel: HamburgerCardModel!
    var questionModel: QuestionModel!
    var separatorLineModel: SeparatorLineModel!
    var pollOptionsModel: PollOptionsModel!
    var miscellaneousModel: PollMiscellaneousModel!
    var bottomHamburgerCardModel: HamburgerCardModel!
    var shadowViewWidth: CGFloat!
    var collectionViewRightPadding: CGFloat!
    var timer: Timer!
    var elapsedSeconds: Int = 0
    
    // MARK: - Constants
    let collectionViewLeftPadding: CGFloat = 5.0
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
    let initialTimerLabelText = "00:00"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topHamburgerCardModel = HamburgerCardModel(state: .top)
        separatorLineModel = SeparatorLineModel()
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
        questionButton.addTarget(self, action: #selector(questionButtonTapped), for: .touchUpInside)
        contentView.addSubview(questionButton)
        
        timerLabel = UILabel()
        timerLabel.font = UIFont.systemFont(ofSize: timerLabelFontSize, weight: .bold)
        timerLabel.textColor = .white
        timerLabel.isHidden = true
        contentView.addSubview(timerLabel)
    }
    
    override func updateConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(collectionViewLeftPadding)
            make.trailing.equalToSuperview().inset(collectionViewRightPadding)
        }
        
        shadowView.snp.updateConstraints { make in
            make.leading.equalTo(collectionView.snp.trailing)
            make.width.equalTo(shadowViewWidth)
            make.centerY.equalToSuperview()
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
    func configure(with delegate: CardCellDelegate, poll: Poll, userRole: UserRole) {
        self.delegate = delegate
        self.poll = poll
        let isVertical = delegate.cardControllerState == .vertical
        let isMember = userRole == .member
        shadowViewWidth = isVertical ? 15 : 0
        collectionViewRightPadding = isVertical ? 0 : collectionViewLeftPadding
        collectionView.isUserInteractionEnabled = !isVertical
        questionButton.isHidden = poll.state == .shared || isVertical || isMember
        timerLabel.isHidden = !(poll.state == .live) || isVertical || isMember
        if poll.state == .live {
            questionButton.setTitle(endQuestionText, for: .normal)
            timerLabel.text = initialTimerLabelText
            runTimer()
        } else if poll.state == .ended {
            questionButton.setTitle(shareResultsText, for: .normal)
        }
        
        questionModel = QuestionModel(question: poll.text)
        pollOptionsModel = buildPollOptionsModel(from: poll, userRole: userRole)
        miscellaneousModel = PollMiscellaneousModel(pollState: poll.state, totalVotes: poll.getTotalResults())
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    // MARK: - Actions
    @objc func questionButtonTapped() {
        if poll.state == .live {
            poll.state = .ended
            questionButton.setTitle(shareResultsText, for: .normal)
            timer.invalidate()
            timerLabel.isHidden = true
            miscellaneousModel = PollMiscellaneousModel(pollState: .ended, totalVotes: miscellaneousModel.totalVotes)
            adapter.performUpdates(animated: false, completion: nil)
            delegate.cardCellDidEndPoll(cardCell: self, poll: poll)
        } else if poll.state == .ended {
            poll.state = .shared
            questionButton.isHidden = true
            miscellaneousModel = PollMiscellaneousModel(pollState: .shared, totalVotes: miscellaneousModel.totalVotes)
            adapter.performUpdates(animated: false, completion: nil)
            delegate.cardCellDidShareResults(cardCell: self, poll: poll)
        }
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
    
    // MARK: - Helpers
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let questionModel = questionModel, let pollOptionsModel = pollOptionsModel, let miscellaneousModel = miscellaneousModel else { return [] }
        var objects: [ListDiffable] = []
        objects.append(topHamburgerCardModel)
        objects.append(questionModel)
        if (userRole == .member && poll.questionType == .freeResponse && poll.state == .live) {
            objects.append(FRInputModel())
        }
        if (userRole == .admin) {
            objects.append(miscellaneousModel)
        }
        objects.append(separatorLineModel)
        objects.append(pollOptionsModel)
        objects.append(bottomHamburgerCardModel)
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is QuestionModel {
            return QuestionSectionController()
        } else if object is FRInputModel {
            return FRInputSectionController(delegate: self)
        } else if object is PollOptionsModel {
            return PollOptionsSectionController(delegate: self)
        } else if object is PollMiscellaneousModel {
            return PollMiscellaneousSectionController()
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

extension CardCell: FRInputSectionControllerDelegate {
    
    func frInputSectionControllerSubmittedResponse(sectionController: FRInputSectionController, response: String) {
        guard let pollOptionsModel = pollOptionsModel else { return }
        switch pollOptionsModel.type {
        case .frOption(optionModels: var frOptionModels):
            let isNewResponse = checkIfResponseIsNew(for: response, frOptionModels: frOptionModels)
            if isNewResponse {
                if let previousAnswer = poll.answer, let previousIndex = indexOfFROptionModel(for: previousAnswer, frOptionModels: frOptionModels) {
                    frOptionModels.remove(at: previousIndex)
                }
                let frOptionModel = FROptionModel(option: response, isAnswer: true, numUpvoted: 0, didUpvote: false)
                frOptionModels.insert(frOptionModel, at: 0)
                let type: PollOptionsModelType = .frOption(optionModels: frOptionModels)
                self.pollOptionsModel = PollOptionsModel(type: type, pollState: pollOptionsModel.pollState)
                adapter.performUpdates(animated: false, completion: nil)
                addFRResponseToPoll(response: response, poll: poll)
            }
            delegate.cardCellDidSubmitChoice(cardCell: self, choice: response)
        default:
            return
        }
    }
    
    // MARK: - Helpers
    private func checkIfResponseIsNew(for response: String, frOptionModels: [FROptionModel]) -> Bool {
        return frOptionModels.first { (frOptionModel) -> Bool in
            return response == frOptionModel.option
            } == nil
    }
    
    private func indexOfFROptionModel(for answer: String, frOptionModels: [FROptionModel]) -> Int? {
        let indexOptionPair = frOptionModels.enumerated().first { (index, frOptionModel) -> Bool in
            return answer == frOptionModel.option
        }
        return indexOptionPair?.offset
    }
    
    private func addFRResponseToPoll(response: String, poll: Poll) {
        poll.options = [response]
        poll.results[response] = [
            ParserKeys.textKey: response,
            ParserKeys.countKey: 1
        ]
    }
}

extension CardCell: PollOptionsSectionControllerDelegate {
    
    var cardControllerState: CardControllerState {
        return delegate.cardControllerState
    }
    
    var userRole: UserRole {
        return delegate.userRole
    }
    
    func pollOptionsSectionControllerDidSubmitChoice(sectionController: PollOptionsSectionController, choice: String) {
        delegate.cardCellDidSubmitChoice(cardCell: self, choice: choice)
    }
    
    func pollOptionsSectionControllerDidUpvoteChoice(sectionController: PollOptionsSectionController, choice: String) {
        delegate.cardCellDidUpvoteChoice(cardCell: self, choice: choice)
    }
    
}
