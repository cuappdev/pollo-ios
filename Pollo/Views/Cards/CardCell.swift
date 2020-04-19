//
//  DateCell.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SnapKit
import SwiftyJSON
import UIKit

protocol CardCellDelegate: class {

    var userRole: UserRole { get }
    var isConnected: Bool { get }

    func cardCellDidEditPoll(cardCell: CardCell, poll: Poll)
    func cardCellDidEndPoll(cardCell: CardCell, poll: Poll)
    func cardCellDidShareResults(cardCell: CardCell, poll: Poll)
    func cardCellDidSubmitChoice(cardCell: CardCell, choice: String, index: Int?)

}

class CardCell: UICollectionViewCell {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var questionButton: UIButton!
    var shadowView: UIView!
    var timerLabel: UILabel!
    
    // MARK: - Data vars
    var adapter: ListAdapter!
    var bottomHamburgerCardModel: HamburgerCardModel!
    var collectionViewRightPadding: CGFloat!
    var miscellaneousModel: PollMiscellaneousModel!
    var poll: Poll!
    var pollOptionsModel: PollOptionsModel!
    var questionModel: QuestionModel!
    var separatorLineModel: SeparatorLineModel!
    var timer: Timer?
    var topHamburgerCardModel: HamburgerCardModel!
    weak var delegate: CardCellDelegate!
    
    // MARK: - Constants
    let collectionViewHorizontalPadding: CGFloat = 8.0
    let endPollText = "End Poll"
    let initialTimerLabelText = "00:00"
    let questionButtonBorderWidth: CGFloat = 1.0
    let questionButtonBottomPadding: CGFloat = 16.0
    let questionButtonCornerRadius: CGFloat = 23.0
    let questionButtonFontSize: CGFloat = 16.0
    let questionButtonHeight: CGFloat = 47.0
    let questionButtonWidth: CGFloat = 160.0
    let responsiveAdminPadding: CGFloat = 32.0
    let responsiveStudentPadding: CGFloat = 50.0
    let resultsSharedText = "Results Shared"
    let shareResultsText = "Share Results"
    let timerLabelBottomPadding: CGFloat = 45.0
    let timerLabelFontSize: CGFloat = 14.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topHamburgerCardModel = HamburgerCardModel(state: .top)
        separatorLineModel = SeparatorLineModel(state: .card)
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
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
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
            make.leading.equalToSuperview().offset(collectionViewHorizontalPadding)
            make.trailing.equalToSuperview().inset(collectionViewHorizontalPadding)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(timerLabelBottomPadding)
            make.height.equalTo(timerLabelFontSize)
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
        let isMember = userRole == .member
        questionButton.isHidden = isMember
        timerLabel.isHidden = !(poll.state == .live) || isMember
        if poll.state == .live {
            questionButton.setTitle(endPollText, for: .normal)
            questionButton.setTitleColor(.clickerRed, for: .normal)
            questionButton.layer.borderColor = UIColor.clickerRed.cgColor
            setTimerText()
            runTimer()
        } else if poll.state == .ended {
            questionButton.setTitle(shareResultsText, for: .normal)
            questionButton.setTitleColor(.white, for: .normal)
            questionButton.layer.borderColor = UIColor.white.cgColor
        } else if poll.state == .shared {
            questionButton.setTitle(resultsSharedText, for: .normal)
            questionButton.setTitleColor(.blueGrey, for: .normal)
            questionButton.layer.borderColor = UIColor.blueGrey.cgColor
        }
        
        questionModel = QuestionModel(question: poll.text)
        pollOptionsModel = buildPollOptionsModel(from: poll, userRole: userRole)
        let didSubmitChoice = userRole == .admin ? false : poll.getSelected() != nil
        miscellaneousModel = PollMiscellaneousModel(questionType: poll.type, pollState: poll.state, totalResponses: poll.getTotalResults(for: userRole), userRole: userRole, didSubmitChoice: didSubmitChoice)
        adapter.performUpdates(animated: false, completion: nil)
    }

    // MARK: - Updates
    func update(with poll: Poll) {
        switch pollOptionsModel.type {
        case .mcResult(resultModels: _):
            guard let pollOptionsSectionController = adapter.sectionController(for: pollOptionsModel) as? PollOptionsSectionController else { return }
            let updatedPollOptionsModelType = buildPollOptionsModelType(from: poll, userRole: userRole)
            // Make sure to call update before updating pollOptionsModel.type so that
            // we don't change the previous pollOptionsModel in pollOptionsSectionController.
            pollOptionsSectionController.update(with: updatedPollOptionsModelType)
            pollOptionsModel.type = updatedPollOptionsModelType
            miscellaneousModel = PollMiscellaneousModel(questionType: poll.type, pollState: poll.state, totalResponses: poll.getTotalResults(for: userRole), userRole: userRole, didSubmitChoice: poll.getSelected() != nil)
            DispatchQueue.main.async {
                self.adapter.performUpdates(animated: false, completion: nil)
            }
        default:
            return
        }
    }
    
    // MARK: - Actions
    @objc func questionButtonTapped() {
        if poll.state == .live {
            poll.state = .ended
            questionButton.setTitle(shareResultsText, for: .normal)
            questionButton.setTitleColor(.white, for: .normal)
            questionButton.layer.borderColor = UIColor.white.cgColor
            timerLabel.isHidden = true
            miscellaneousModel = PollMiscellaneousModel(questionType: poll.type, pollState: .ended, totalResponses: miscellaneousModel.totalResponses, userRole: userRole, didSubmitChoice: poll.getSelected() != nil)
            adapter.performUpdates(animated: false, completion: nil)
            delegate?.cardCellDidEndPoll(cardCell: self, poll: poll)
        } else if poll.state == .ended {
            poll.state = .shared
            questionButton.setTitle(resultsSharedText, for: .normal)
            questionButton.setTitleColor(.blueGrey, for: .normal)
            questionButton.layer.borderColor = UIColor.blueGrey.cgColor
            miscellaneousModel = PollMiscellaneousModel(questionType: poll.type, pollState: .shared, totalResponses: miscellaneousModel.totalResponses, userRole: userRole, didSubmitChoice: poll.getSelected() != nil)
            adapter.performUpdates(animated: false, completion: nil)
            delegate?.cardCellDidShareResults(cardCell: self, poll: poll)
        }
    }
    
    @objc func setTimerText() {
        guard let start = poll.createdAt else {
            self.timerLabel.text = self.initialTimerLabelText
            return
        }
        let elapsedSeconds = Int(NSDate().timeIntervalSince(convertUnixStringToDate(start)))
        if elapsedSeconds < 10 {
            timerLabel.text = "00:0\(elapsedSeconds)"
        } else if elapsedSeconds < 60 {
            timerLabel.text = "00:\(elapsedSeconds)"
        } else {
            let minutes = Int(elapsedSeconds / 60)
            let seconds = elapsedSeconds - minutes * 60
            if elapsedSeconds < 600 {
                if seconds < 10 {
                    timerLabel.text = "0\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "0\(minutes):\(seconds)"
                }
            } else {
                if seconds < 10 {
                    timerLabel.text = "\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "\(minutes):\(seconds)"
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func runTimer() {
        if let t = timer {
            t.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTimerText), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let questionModel = questionModel, let pollOptionsModel = pollOptionsModel, let miscellaneousModel = miscellaneousModel else { return [] }
        return [topHamburgerCardModel, questionModel, miscellaneousModel, separatorLineModel, pollOptionsModel]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is QuestionModel {
            return QuestionSectionController(delegate: self, userRole: userRole)
        } else if object is PollOptionsModel {
            return PollOptionsSectionController(delegate: self, correctAnswer: poll.correctAnswer)
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

extension CardCell: PollOptionsSectionControllerDelegate {
    
    var userRole: UserRole {
        return delegate.userRole
    }
    
    var maxCellHeight: CGFloat {
        let questionCellWidth = self.frame.width - LayoutConstants.cardHorizontalPadding * 2 - LayoutConstants.moreButtonWidth
        let questionCellHeight = questionModel.question.height(forConstrainedWidth: questionCellWidth, font: ._20BoldFont)
        let cardCellTopHeight = LayoutConstants.hamburgerCardCellHeight + questionCellHeight + LayoutConstants.pollMiscellaneousCellHeight + LayoutConstants.separatorLineCardCellHeight
        let belowAdminCardCellHeight = questionButtonHeight + questionButtonBottomPadding + timerLabelFontSize + timerLabelBottomPadding + responsiveAdminPadding
        return self.frame.height - (cardCellTopHeight + (delegate.userRole == .admin ? belowAdminCardCellHeight : responsiveStudentPadding))
    }
    
    var isConnected: Bool {
        return delegate.isConnected
    }
    
    func pollOptionsSectionControllerDidSubmitChoice(sectionController: PollOptionsSectionController, choice: String, index: Int?) {
        miscellaneousModel = PollMiscellaneousModel(questionType: miscellaneousModel.questionType, pollState: miscellaneousModel.pollState, totalResponses: miscellaneousModel.totalResponses, userRole: miscellaneousModel.userRole, didSubmitChoice: true)
        adapter.performUpdates(animated: false, completion: nil)
        delegate.cardCellDidSubmitChoice(cardCell: self, choice: choice, index: index)
    }
    
}

// MARK: QuestionSectionController Delegate
extension CardCell: QuestionSectionControllerDelegate {
    func questionSectionControllerDidEditPoll(_ controller: QuestionSectionController) {
        delegate.cardCellDidEditPoll(cardCell: self, poll: poll)
    }
}
