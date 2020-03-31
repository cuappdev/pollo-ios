//
//  CardController+Extension.swift
//  Pollo
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
            let emptyStateController = EmptyStateSectionController(session: session)
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

        guard let indexOfChoice = poll.answerChoices.firstIndex(where: { $0.text == choice }) else { return }
        let pollChoice = PollChoice(letter: poll.answerChoices[indexOfChoice].letter, text: choice)
        emitAnswer(pollChoice: pollChoice, message: Routes.serverAnswer)
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

    func startPoll(text: String, options: [String], state: PollState, answerChoices: [PollResult], correctAnswer: String?, shouldPopViewController: Bool) {

        createPollButton.isUserInteractionEnabled = false
        createPollButton.isHidden = true

        let correct = correctAnswer ?? ""

        session.isLive = true
        // EMIT START QUESTION
        let newPoll = Poll(text: text, answerChoices: answerChoices, correctAnswer: correctAnswer, userAnswers: [:], state: state)
        newPoll.createdAt = Date().secondsString
        let answerChoicesDict = answerChoices.compactMap { $0.dictionary }
        let newPollDict: [String: Any] = [
            "text": text,
            "answerChoices": answerChoicesDict,
            "state": "live",
            "correctAnswer": correct,
            "userAnswers": [String: [PollChoice]]()
        ]

        socket.socket.emit(Routes.serverStart, newPollDict)

        pollsDateModel.polls.append(newPoll)
        if pollsDateModel.dateValue.isSameDay(as: Date()) {
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
    private func buildEmptyResultsFromOptions(options: [String]) -> [String: JSON] {
        var results: [String: JSON] = [:]
        options.enumerated().forEach { (index, option) in
            let infoDict: JSON = [
                RequestKeys.textKey: option,
                RequestKeys.countKey: 0
            ]
            let letterChoice = intToMCOption(index) // i.e. A, B, C, ...
            let key = letterChoice
            results[key] = infoDict
        }
        return results
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

    func sessionConnected() {
        isConnected = true
    }
    
    func sessionDisconnected() {
        isConnected = false
    }

    func sessionReconnecting() {
        isConnected = false
    }

    func receivedUserCount(_ count: Int) {
        numberOfPeople = count
        peopleButton.setTitle("\(count)", for: .normal)
        peopleButton.sizeToFit()
    }
    
    func pollStarted(_ poll: Poll, userRole: UserRole) {
        if !pollsDateModel.dateValue.isSameDay(as: Date()) {
            delegate?.pollStarted(poll, userRole: userRole)
            return
        }

        pollsDateModel.polls = pollsDateModel.polls.filter { !$0.isEqual(toDiffableObject: poll) }
        pollsDateModel.polls.append(poll)

        adapter.performUpdates(animated: false) { completed in
            if completed {
                self.scrollToLatestPoll()
            }
        }
    }
    
    func pollEnded(_ poll: Poll, userRole: UserRole) {
        if !pollsDateModel.dateValue.isSameDay(as: Date()) {
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
            updatedPoll.userAnswers = poll.userAnswers
            updateLatestPoll(with: updatedPoll)
            adapter.performUpdates(animated: false, completion: nil)
        }
    }

    func pollDeleted(_ pollID: String, userRole: UserRole) {
        if !pollsDateModel.dateValue.isSameDay(as: pollsDateModel.dateValue) {
            delegate?.pollDeleted(pollID, userRole: userRole)
            return
        }
        guard let deleteIndex = pollsDateModel.polls.firstIndex(where: { $0.id == pollID }) else { return }
        pollsDateModel.polls.remove(at: deleteIndex)
        currentIndex = currentIndex == pollsDateModel.polls.count ? currentIndex - 1 : currentIndex
        updateCountLabelText()
        adapter.performUpdates(animated: true, completion: nil)
    }

    func pollDeletedLive() {
        if !pollsDateModel.dateValue.isSameDay(as: Date()) {
            delegate?.pollDeletedLive()
            return
        }
        guard let deleteIndex = pollsDateModel.polls.firstIndex(where: { $0.state == .live }) else { return }
        pollsDateModel.polls.remove(at: deleteIndex)
        currentIndex = currentIndex == pollsDateModel.polls.count ? currentIndex - 1 : currentIndex
        updateCountLabelText()
        adapter.performUpdates(animated: false, completion: nil)
        if pollsDateModel.polls.isEmpty {
            goBack()
        }
    }
    
    func receivedResults(_ poll: Poll, userRole: UserRole) {
        if !pollsDateModel.dateValue.isSameDay(as: Date()) {
            delegate?.receivedResults(poll)
            return
        }
        updateLatestPoll(with: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func updatedTally(_ poll: Poll, userRole: UserRole) {
        if !pollsDateModel.dateValue.isSameDay(as: Date()) {
            delegate?.updatedTally(poll)
            return
        }
        // Live MC polls for Admins should have the highlightView animate which is why we don't want to
        updateLiveCardCell(with: poll)
        adapter.performUpdates(animated: true, completion: nil)
    }

    /// These two functions should only get called upon joining a socket
    /// so it should only be handled in PollsDateViewController
    func receivedResultsLive(_ poll: Poll, userRole: UserRole) {
        receivedResults(poll, userRole: userRole)
    }

    func updatedTallyLive(_ poll: Poll, userRole: UserRole) {}

    func updateLiveCardCell(with poll: Poll) {
        guard let latestPoll = pollsDateModel.polls.last,
            latestPoll.state == .live,
            let latestPollSectionController = adapter.sectionController(forSection: pollsDateModel.polls.count - 1) as? PollSectionController
            else { return }
        latestPoll.update(with: poll)
        latestPollSectionController.update(with: latestPoll)
    }

    // MARK: Helpers
    func emitAnswer(pollChoice: PollChoice, message: String) {
        let data: [String: Any] = [
            RequestKeys.letterKey: pollChoice.letter as Any,
            RequestKeys.textKey: pollChoice.text
        ]
        socket.socket.emit(message, data)
    }
    
    func emitEndPoll() {
        session.isLive = false
        socket.socket.emit(Routes.serverEnd, [])
    }

    func emitDeletePoll(at index: Int) {
        switch pollsDateModel.polls[index].state {
        case .live:
            socket.socket.emit(Routes.serverDeleteLive)
            session.isLive = false
            pollsDateModel.polls[index].state = .ended
            createPollButton.isUserInteractionEnabled = true
            createPollButton.isHidden = false
        case .ended, .shared:
            socket.socket.emit(Routes.serverDelete, pollsDateModel.polls[index].id ?? "")
        }
    }
    
    func emitShareResults() {
        let poll = pollsDateModel.polls[currentIndex]
        socket.socket.emit(Routes.serverShare, poll.id ?? "")
        Analytics.shared.log(with: SharedResultsPayload())
    }
    
    func updatedPollOptions(for poll: Poll) -> [PollResult] {
        return poll.answerChoices
    }
    
    func updateWithCurrentState(poll: Poll) {
        guard let latestPoll = pollsDateModel.polls.last else { return }
        updateLatestPoll(with: latestPoll)
    }
    
    func updateLatestPoll(with poll: Poll) {
        if pollsDateModel.polls.isEmpty { return }
        let numPolls = pollsDateModel.polls.count
        let latestPollIndex = pollsDateModel.polls.firstIndex { latestPoll -> Bool in
            if let pollId = poll.id, let latestPollId = latestPoll.id {
                return pollId == latestPollId
            }
            return false
        }
        pollsDateModel.polls[latestPollIndex ?? numPolls - 1] = poll
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
                self.currentIndex = self.currentIndex == self.pollsDateModel.polls.count ? self.currentIndex - 1 : self.currentIndex
            }
            self.updateCountLabelText()
            if self.pollsDateModel.polls.isEmpty {
                self.goBack()
            }
        }
    }

    func editPollViewControllerDidReopenPoll(sender: EditPollViewController) { }

}
