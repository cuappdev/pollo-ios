//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import Presentr
import SwiftyJSON
import UIKit

extension CardController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if pollsDateModel.polls.isEmpty {
            let type: EmptyStateType = .cardController(userRole: userRole)
            return [EmptyStateModel(type: type)]
        }
        return pollsDateModel.polls
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Poll {
            let pollSectionController = PollSectionController(delegate: self)
            return pollSectionController
        } else {
            let shouldDisplayNameView = userRole == .admin && session.name == session.code
            let emptyStateController = EmptyStateSectionController(session: session, shouldDisplayNameView: shouldDisplayNameView, nameViewDelegate: self)
            return emptyStateController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CardController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomModalPresentationController(presented: presented, presenting: presenting, style: .upToStatusBar)
    }
}

extension CardController: NavigationTitleViewDelegate {

    func navigationTitleViewNavigationButtonTapped() {
        delegate?.navigationTitleViewNavigationButtonTapped()
    }

}

extension CardController: PollSectionControllerDelegate {
    
    var role: UserRole {
        return userRole
    }
    
    func pollSectionControllerDidSubmitChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll) {
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
        emitAnswer(answer: answer, message: Routes.serverTally)
    }

    func pollSectionControllerDidUpvote(sectionController: PollSectionController, answerId: String) {
        let upvoteObject: [String: Any] = [
            RequestKeys.answerIdKey: answerId,
            RequestKeys.googleIDKey: User.currentUser?.id ?? ""
        ]
        socket.socket.emit(Routes.serverUpvote, upvoteObject)
    }
    
    func pollSectionControllerDidEndPoll(sectionController: PollSectionController, poll: Poll) {
        createPollButton.isUserInteractionEnabled = true
        createPollButton.isHidden = false
        emitEndPoll()
    }
    
    func pollSectionControllerDidShareResultsForPoll(sectionController: PollSectionController, poll: Poll) {
        emitShareResults()
    }

    func pollSectionControllerDidEditPoll(sectionController: PollSectionController, poll: Poll) {
        let width = ModalSize.full
        let modalHeight = editModalHeight + view.safeAreaInsets.bottom
        let height = ModalSize.custom(size: Float(modalHeight))
        let originY = view.frame.height - modalHeight + UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let presenter = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let editPollVC = EditPollViewController(.poll, delegate: self, session: session, userRole: userRole, countLabelText: countLabel.text)
        editPollVC.modalPresentationCapturesStatusBarAppearance = true
        let navigationVC = UINavigationController(rootViewController: editPollVC)
        customPresentViewController(presenter, viewController: navigationVC, animated: true, completion: nil)
    }

}

extension CardController: PollBuilderViewControllerDelegate {
    
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState, correctAnswer: String?, shouldPopViewController: Bool) {
        createPollButton.isUserInteractionEnabled = false
        createPollButton.isHidden = true
        
        var correct = ""
        if let correctAnswer = correctAnswer {
            correct = correctAnswer
        }
        
        // EMIT START QUESTION
        let socketQuestion: [String: Any] = [
            RequestKeys.textKey: text,
            RequestKeys.typeKey: type.descriptionForServer,
            RequestKeys.optionsKey: options,
            RequestKeys.sharedKey: state == .shared,
            RequestKeys.correctAnswerKey: correct
        ]
        socket.socket.emit(Routes.serverStart, socketQuestion)
        let results = buildEmptyResultsFromOptions(options: options, questionType: type)
        let pollResults = formatResults(results: results)
        let newPoll = Poll(text: text, questionType: type, options: options, results: pollResults, state: state, correctAnswer: correctAnswer)
        pollsDateModel.polls.append(newPoll)
        if pollsDateModel.date == getTodaysDate() {
            adapter.performUpdates(animated: false) { completed in
                if completed {
                    self.scrollToLatestPoll()
                }
            }
            return
        }

        if shouldPopViewController {
            navigationController?.popViewController(animated: false)
        }
        delegate?.cardControllerDidStartNewPoll(poll: newPoll)
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    private func buildEmptyResultsFromOptions(options: [String], questionType: QuestionType) -> [String: JSON] {
        var results: [String: JSON] = [:]
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
        navigationTitleView.configure(primaryText: session.name, secondaryText: "Code: \(session.code)")
    }
    
}

extension CardController: UIScrollViewDelegate {
    
    // MARK: - Handle paging animation of horizontal collection view
    private func indexOfHorizontalCard(offset: CGPoint) -> Int {
        let proportionalOffset = (offset.x + collectionViewHorizontalInset) / cvItemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = objects(for: adapter).count
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }

    /// what contentOffset would be if the nearest card were centered
    private func closestDiscreteOffset(to offset: CGPoint) -> CGFloat {
        let rem = remainder(offset.x + collectionViewHorizontalInset, cvItemWidth)
        return offset.x - rem
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        wasScrolledToIndex = indexOfHorizontalCard(offset: scrollView.contentOffset)
        startingScrollingOffset = scrollView.contentOffset
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let willScrollToIndex = self.indexOfHorizontalCard(offset: targetContentOffset.pointee)
        let canSwipeNext = wasScrolledToIndex + 1 < pollsDateModel.polls.count && velocity.x > swipeVelocityThreshold
        let canSwipePrev = wasScrolledToIndex - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        var newCount: Int
        var direction: Int
        
        if willScrollToIndex == wasScrolledToIndex {
            if canSwipeNext || canSwipePrev {
                // scrolled short and fast, should snap to next/prev cell
                direction = canSwipeNext ? 1 : -1
                newCount =  wasScrolledToIndex + direction
            } else {
                // scrolled short and slow, should snap back to same cell
                direction = 0
                newCount = wasScrolledToIndex
            }
        } else {
            // scrolled far, should move to next/prev cell
            direction =  willScrollToIndex > wasScrolledToIndex ? 1 : -1
            newCount = wasScrolledToIndex + direction
        }
        
        let deltaOffset = cvItemWidth * CGFloat(direction)
        let toValue = closestDiscreteOffset(to: startingScrollingOffset) + deltaOffset
        
        targetContentOffset.pointee = CGPoint(x: toValue, y: 0)
        currentIndex = newCount
        updateCountLabelText()
    }
    
    func scrollToLatestPoll() {
        let indexOfLatestSection = pollsDateModel.polls.count - 1
        let lastIndexPath = IndexPath(item: 0, section: indexOfLatestSection)
        self.collectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
        currentIndex = indexOfLatestSection
        updateCountLabelText()
    }
}

extension CardController: SocketDelegate {
    
    func sessionConnected() {}
    
    func sessionDisconnected() {}
    
    func receivedUserCount(_ count: Int) {
        numberOfPeople = count
        peopleButton.setTitle("\(count)", for: .normal)
        peopleButton.sizeToFit()
    }
    
    func pollStarted(_ poll: Poll, userRole: UserRole) {
        if pollsDateModel.date != getTodaysDate() {
            delegate?.pollStarted(poll, userRole: userRole)
            return
        }
        if let latestPoll = pollsDateModel.polls.last, latestPoll.state == .live {
            return
        }
        if pollsDateModel.polls.contains(where: { otherPoll -> Bool in
            return otherPoll.id == poll.id
        }) { return }
        pollsDateModel.polls.append(poll)
        adapter.performUpdates(animated: false) { completed in
            if completed {
                self.scrollToLatestPoll()
            }
        }
    }
    
    func pollEnded(_ poll: Poll, userRole: UserRole) {
        if pollsDateModel.date != getTodaysDate() {
            delegate?.pollEnded(poll, userRole: userRole)
            return
        }
        guard let latestPoll = pollsDateModel.polls.last else { return }
        switch userRole {
        case .admin:
            latestPoll.id = poll.id
            updateLatestPoll(with: latestPoll)
        case .member:
            let updatedPoll = Poll(poll: latestPoll, state: .ended)
            updatedPoll.id = poll.id
            updateLatestPoll(with: updatedPoll)
            adapter.performUpdates(animated: false, completion: nil)
        }
    }

    func pollDeleted(_ pollID: Int, userRole: UserRole) {
        if pollsDateModel.date != getTodaysDate() {
            delegate?.pollDeleted(pollID, userRole: userRole)
            return
        }
        guard let deleteIndex = pollsDateModel.polls.firstIndex(where: { $0.id == pollID }) else { return }
        pollsDateModel.polls.remove(at: deleteIndex)
        currentIndex = currentIndex == 0 ? currentIndex : currentIndex - 1
        updateCountLabelText()
        adapter.performUpdates(animated: false, completion: nil)
    }

    func pollDeletedLive() {
        if pollsDateModel.date != getTodaysDate() {
            delegate?.pollDeletedLive()
            return
        }
        pollsDateModel.polls.remove(at: currentIndex)
        currentIndex = currentIndex == 0 ? currentIndex : currentIndex - 1
        updateCountLabelText()
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func receivedResults(_ currentState: CurrentState) {
        if pollsDateModel.date != getTodaysDate() {
            delegate?.receivedResults(currentState)
            return
        }
        guard let latestPoll = pollsDateModel.polls.last else { return }
        // Free Response receives results in live state
        if latestPoll.state == .live && latestPoll.questionType == .freeResponse {
            // For FR, options is initialized to be an empty array so we need to update it whenever we receive results.
            latestPoll.options = updatedPollOptions(for: latestPoll, currentState: currentState)
            updateLiveCardCell(with: currentState)
        } else {
            let pollState: PollState = latestPoll.questionType == .multipleChoice ? .shared : latestPoll.state
            updateWithCurrentState(currentState: currentState, pollState: pollState)
            self.adapter.performUpdates(animated: false, completion: nil)
        }
    }

    func updatedTally(_ currentState: CurrentState) {
        if pollsDateModel.date != getTodaysDate() {
            delegate?.updatedTally(currentState)
            return
        }
        guard let latestPoll = pollsDateModel.polls.last else { return }
        // Live MC polls for Admins should have the highlightView animate which is why we don't want to
        // do adapter.performUpdates
        if latestPoll.state == .live && latestPoll.questionType == .multipleChoice && userRole == .admin {
            updateLiveCardCell(with: currentState)
        } else {
            updateWithCurrentState(currentState: currentState, pollState: nil)
            self.adapter.performUpdates(animated: false, completion: nil)
        }
    }

    /// These two functions should only get called upon joining a socket
    /// so it should only be handled in PollsDateViewController
    func receivedResultsLive(_ currentState: CurrentState) {}
    func updatedTallyLive(_ currentState: CurrentState) {}

    func updateLiveCardCell(with currentState: CurrentState) {
        guard let latestPoll = pollsDateModel.polls.last,
            latestPoll.state == .live,
            let latestPollSectionController = adapter.sectionController(forSection: pollsDateModel.polls.count - 1) as? PollSectionController
            else { return }
        latestPoll.update(with: currentState)
        latestPollSectionController.update(with: latestPoll)
    }

    // MARK: Helpers
    func emitAnswer(answer: Answer, message: String) {
        let data: [String: Any] = [
            RequestKeys.googleIDKey: User.currentUser?.id ?? "",
            RequestKeys.pollKey: answer.pollId,
            RequestKeys.choiceKey: answer.choice,
            RequestKeys.textKey: answer.text
        ]
        socket.socket.emit(message, data)
    }
    
    func emitEndPoll() {
        socket.socket.emit(Routes.serverEnd, [])
    }

    func emitDeletePoll(at index: Int) {
        switch pollsDateModel.polls[index].state {
        case .live:
            socket.socket.emit(Routes.serverDeleteLive, pollsDateModel.polls[index].id)
            pollsDateModel.polls[index].state = .ended
            createPollButton.isUserInteractionEnabled = true
            createPollButton.isHidden = false
        case .ended, .shared:
            socket.socket.emit(Routes.serverDelete, pollsDateModel.polls[index].id)
        }
    }
    
    func emitShareResults() {
        socket.socket.emit(Routes.serverShare, [])
        Analytics.shared.log(with: SharedResultsPayload())
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
        guard let latestPoll = pollsDateModel.polls.last else { return }
        // For FR, options is initialized to be an empty array so we need to update it whenever we receive results.
        if latestPoll.questionType == .freeResponse {
            latestPoll.options = updatedPollOptions(for: latestPoll, currentState: currentState)
        }
        
        let updatedPoll = Poll(poll: latestPoll, currentState: currentState, updatedPollState: pollState)
        updateLatestPoll(with: updatedPoll)
    }
    
    func updateLatestPoll(with poll: Poll) {
        if pollsDateModel.polls.isEmpty { return }
        let numPolls = pollsDateModel.polls.count
        pollsDateModel.polls[numPolls - 1] = poll
    }

}

// MARK: - EditPollViewControllerDelegate
extension CardController: EditPollViewControllerDelegate {

    func editPollViewControllerDidUpdateName(for userRole: UserRole) { }

    func editPollViewControllerDidDeleteSession(for userRole: UserRole) { }

    func editPollViewControllerDidDeletePoll(sender: EditPollViewController) {
        emitDeletePoll(at: currentIndex)
        pollsDateModel.polls.remove(at: currentIndex)
        sender.dismiss(animated: true, completion: nil)
        adapter.performUpdates(animated: true) { completed in
            if completed && !self.pollsDateModel.polls.isEmpty {
                // Move current index based on which poll was deleted
                self.currentIndex = self.currentIndex == 0 ? self.currentIndex : self.currentIndex - 1
            }
            self.updateCountLabelText()
        }
    }

    func editPollViewControllerDidReopenPoll(sender: EditPollViewController) {
        // Commented out for now because reopening functionality needs to be fleshed out more
//        let poll = pollsDateModel.polls[currentIndex]
//        sender.dismiss(animated: true, completion: nil)
//        startPoll(text: poll.text, type: poll.questionType, options: poll.options, state: .live, correctAnswer: poll.correctAnswer, shouldPopViewController: false)
    }

}
