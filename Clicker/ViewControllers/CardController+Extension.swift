//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SwiftyJSON
import UIKit

extension CardController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch state {
        case .horizontal:
            if (currentIndex > -1) {
                return pollsDateArray[currentIndex].polls
            } else {
                return [EmptyStateModel(userRole: userRole)]
            }
        default:
            return pollsDateArray.enumerated().compactMap({ index,pollsDateModel -> PollDateModel? in
                if let latestPoll = pollsDateModel.polls.last {
                    collectionView.isScrollEnabled = true
                    return PollDateModel(date: pollsDateModel.date, poll: latestPoll, index: index)
                }
                return nil
            })
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Poll {
            let pollSectionController = PollSectionController(delegate: self)
            return pollSectionController
        } else if object is PollDateModel {
            let pollDateSectionController = PollDateSectionController(delegate: self)
            return pollDateSectionController
        } else {
            let emptyStateController = EmptyStateSectionController(session: session, userRole: userRole, nameViewDelegate: self)
            return emptyStateController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CardController: PollSectionControllerDelegate {
    
    var cardControllerState: CardControllerState {
        return state
    }
    
    var role: UserRole {
        return userRole
    }
    
    func pollSectionControllerDidSubmitChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll) {
        poll.answer = choice
        var choiceForAnswer: String
        // choiceForAnswer should be "A" or "B" for multiple choice and the actual response for free response
        switch poll.questionType {
        case .multipleChoice:
            guard let indexOfChoice = poll.options.index(of: choice) else { return }
            choiceForAnswer = intToMCOption(indexOfChoice)
        case .freeResponse:
            choiceForAnswer = choice
        }
        let answer = Answer(text: choice, choice: choiceForAnswer, pollId: poll.id)
        emitAnswer(answer: answer, message: Routes.tally)
    }
    
    func pollSectionControllerDidUpvoteChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll) {
        // You can only upvote for FR questions
        if poll.questionType == .multipleChoice { return }
        let answer = Answer(text: choice, choice: choice, pollId: poll.id)
        emitAnswer(answer: answer, message: Routes.upvote)
    }
    
    func pollSectionControllerDidEndPoll(sectionController: PollSectionController, poll: Poll) {
        createPollButton.isUserInteractionEnabled = true
        createPollButton.isHidden = false
        emitEndPoll()
    }
    
    func pollSectionControllerDidShareResultsForPoll(sectionController: PollSectionController, poll: Poll) {
        emitShareResults()
    }
}

extension CardController: PollDateSectionControllerDelegate {
    
    func switchToHorizontalWith(index: Int) {
        currentIndex = index
        switchTo(state: .horizontal)
    }
    
    func pollDateSectionControllerDidSubmitChoiceForPoll(sectionController: PollDateSectionController, choice: String, poll: Poll) {
        let answer = Answer(text: poll.text, choice: choice, pollId: poll.id)
        emitAnswer(answer: answer, message: Routes.tally)
    }
    
    func pollDateSectionControllerDidEndPoll(sectionController: PollDateSectionController, poll: Poll) {
        emitEndPoll()
    }
}

extension CardController: PollBuilderViewControllerDelegate {
    
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState) {
        createPollButton.isUserInteractionEnabled = false
        createPollButton.isHidden = true
        
        // EMIT START QUESTION
        let socketQuestion: [String:Any] = [
            RequestKeys.textKey: text,
            RequestKeys.typeKey: type.descriptionForServer,
            RequestKeys.optionsKey: options,
            RequestKeys.sharedKey: state == .shared
        ]
        socket.socket.emit(Routes.start, socketQuestion)
        let results = buildEmptyResultsFromOptions(options: options, questionType: type)
        let newPoll = Poll(text: text, questionType: type, options: options, results: results, state: state, answer: nil)
        appendPoll(poll: newPoll)
        adapter.performUpdates(animated: false) { (completed) in
            if (completed) {
                self.scrollToLatestPoll()
            }
        }
    }
    
    // MARK: - Helpers
    private func buildEmptyResultsFromOptions(options: [String], questionType: QuestionType) -> [String:JSON] {
        var results: [String:JSON] = [:]
        options.enumerated().forEach { (index, option) in
            let infoDict: JSON = [
                RequestKeys.textKey: option,
                RequestKeys.countKey: 0
            ]
            let letterChoice = intToMCOption(index) // i.e. A, B, C, ...
            let key = questionType == .multipleChoice ? letterChoice : option
            results[key] = infoDict
        }
        return results
    }
}

extension CardController: NameViewDelegate {
    
    func nameViewDidUpdateSessionName() {
        navigationTitleView.updateNameAndCode(name: session.name, code: session.code)
    }
    
}

extension CardController: UIScrollViewDelegate {
    
    // MARK: - Handle paging animation of horizontal collection view
    private func indexOfHorizontalCard() -> Int {
        let itemWidth = view.frame.width * 0.9
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = objects(for: adapter).count
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfHorizontalCard()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if state == .vertical {
            return
        }
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset

        // calculate where scrollView should snap to:
        let indexOfHorizontalCard = self.indexOfHorizontalCard()

        // calculate conditions:
        let dataSourceCount = objects(for: adapter).count
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfHorizontalCard == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {

            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let itemWidth = view.frame.width * 0.9
            let toValue = itemWidth * CGFloat(snapToIndex)

            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)

        } else {
            // Scroll to correct section
            let indexPath = IndexPath(row: 0, section: indexOfHorizontalCard)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updateCountLabelText(with: indexOfHorizontalCard)
        }
    }

    func scrollToLatestPoll() {
        let indexOfLatestSection = pollsDateArray[currentIndex].polls.count - 1
        let lastIndexPath = IndexPath(item: 0, section: indexOfLatestSection)
        self.collectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
        updateCountLabelText(with: indexOfLatestSection)
    }
}

extension CardController: SocketDelegate {
    
    func sessionConnected() {}
    
    func sessionDisconnected() {}
    
    func receivedUserCount(_ count: Int) {
        peopleButton.setTitle("\(count)", for: .normal)
    }
    
    func pollStarted(_ poll: Poll) {
        if (userRole == .admin) { return }
        appendPoll(poll: poll)
        adapter.performUpdates(animated: false) { (completed) in
            if (completed) {
                self.scrollToLatestPoll()
            }
        }
    }
    
    func pollEnded(_ poll: Poll, userRole: UserRole) {
        guard let latestPoll = getLatestPoll() else { return }
        if userRole == .admin {
            latestPoll.id = poll.id
            updateLatestPoll(with: latestPoll)
            return
        }
        switch poll.questionType {
        case .freeResponse:
            let updatedPoll = Poll(id: latestPoll.id, text: latestPoll.text, questionType: latestPoll.questionType, options: latestPoll.options, results: latestPoll.results, state: .ended, answer: latestPoll.answer)
            updateLatestPoll(with: updatedPoll)
        case .multipleChoice:
            endPoll(poll: poll)
        }
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func receivedResults(_ currentState: CurrentState) {
        updateWithCurrentState(currentState: currentState, pollState: .shared)
        adapter.performUpdates(animated: false, completion: nil)
    }
        
    func updatedTally(_ currentState: CurrentState) {
        updateWithCurrentState(currentState: currentState, pollState: nil)
        adapter.performUpdates(animated: false, completion: nil)
    }

    // MARK: Helpers
    func emitAnswer(answer: Answer, message: String) {
        let data: [String:Any] = [
            RequestKeys.googleIdKey: User.currentUser?.id,
            RequestKeys.pollKey: answer.pollId,
            RequestKeys.choiceKey: answer.choice,
            RequestKeys.textKey: answer.text
        ]
        socket.socket.emit(message, data)
    }
    
    func emitEndPoll() {
        socket.socket.emit(Routes.end, [])
    }
    
    func emitShareResults() {
        socket.socket.emit(Routes.share, [])
    }
    
    func appendPoll(poll: Poll) {
        if (currentIndex == -1) {
            let date = getTodaysDate()
            let newPollsDate = PollsDateModel(date: date, polls: [poll])
            pollsDateArray.append(newPollsDate)
            currentIndex = 0
            return
        }
        pollsDateArray.last?.polls.append(poll)
    }
    
    func endPoll(poll: Poll) {
        updateLatestPoll(with: poll)
    }
    
    func updatedPollOptions(for poll: Poll, currentState: CurrentState) -> [String] {
        var updatedOptions = poll.options.filter { (option) -> Bool in
            return currentState.results[option] != nil
        }
        let newOptions = currentState.results.keys.filter { return !poll.options.contains($0) }
        updatedOptions.insert(contentsOf: newOptions, at: 0)
        return updatedOptions
    }
    
    func updateWithCurrentState(currentState: CurrentState, pollState: PollState?) {
        guard let latestPoll = getLatestPoll() else { return }
        let updatedPollState = pollState ?? latestPoll.state
        // For FR, options is initialized to be an empty array so we need to update it whenever we receive results.
        if latestPoll.questionType == .freeResponse {
            latestPoll.options = updatedPollOptions(for: latestPoll, currentState: currentState)
        }
        let updatedPoll = Poll(id: currentState.pollId, text: latestPoll.text, questionType: latestPoll.questionType, options: latestPoll.options, results: currentState.results, state: updatedPollState, answer: latestPoll.answer)
        updateLatestPoll(with: updatedPoll)
    }
    
    func updateLatestPoll(with poll: Poll) {
        guard let latestPollsDateModel = pollsDateArray.last else { return }
        let todaysDate = getTodaysDate()
        if (latestPollsDateModel.date != todaysDate) {
            // User has no polls for today yet
            let todayPollsDateModel = PollsDateModel(date: todaysDate, polls: [poll])
            pollsDateArray.append(todayPollsDateModel)
        } else {
            // User has polls for today, so just update latest poll for today
            let todayPolls = latestPollsDateModel.polls
            poll.answer = pollsDateArray.last?.polls.last?.answer
            pollsDateArray[pollsDateArray.count - 1].polls[todayPolls.count - 1] = poll
        }
    }
    
    func getLatestPoll() -> Poll? {
        guard let latestPollsDateModel = pollsDateArray.last else { return nil }
        return latestPollsDateModel.polls.last
    }
    
}
