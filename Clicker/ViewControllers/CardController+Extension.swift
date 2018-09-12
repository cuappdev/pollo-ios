//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import UIKit

extension CardController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch state {
        case .horizontal:
            if (currentIndex > -1) {
                collectionView.isScrollEnabled = true
                return pollsDateArray[currentIndex].polls
            } else {
                collectionView.isScrollEnabled = false
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
        let answer = Answer(text: poll.text, choice: choice, pollId: poll.id)
        emitAnswer(answer: answer)
    }
    
}

extension CardController: PollDateSectionControllerDelegate {
    
    func switchToHorizontalWith(index: Int) {
        currentIndex = index
        switchTo(state: .horizontal)
    }
    
    func pollDateSectionControllerDidSubmitChoiceForPoll(sectionController: PollDateSectionController, choice: String, poll: Poll) {
        let answer = Answer(text: poll.text, choice: choice, pollId: poll.id)
        emitAnswer(answer: answer)
    }
    
}

extension CardController: StartPollDelegate {
    
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState) {
        createPollButton.isUserInteractionEnabled = false
        
        // EMIT START QUESTION
        let socketQuestion: [String:Any] = [
            "text": text,
            "type": type.descriptionForServer,
            "options": options,
            "shared": state == .shared
        ]
        socket.socket.emit(Routes.start, [socketQuestion])
        let newPoll = Poll(id: 0, text: text, questionType: type, options: options, results: [:], state: state, answer: nil)
        appendPoll(poll: newPoll)
        adapter.performUpdates(animated: false, completion: nil)
        let lastIndexPath = IndexPath(item: 0, section: 0) // TODO: implement scrolling to end of CV
        self.collectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func appendPoll(poll: Poll) {
        let date = "today"
        let newPollDate = PollsDateModel(date: date, polls: [poll])
        
        if pollsDateArray == nil {
            pollsDateArray = [newPollDate]
            currentIndex = 0
            return
        }
        if (currentIndex != pollsDateArray.count - 1) || (currentIndex == -1) {
            pollsDateArray.append(newPollDate)
            currentIndex = pollsDateArray.count - 1
        } else {
            pollsDateArray[currentIndex].polls.append(poll)
        }
        updateCount()
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
        }
    }
}

extension CardController: SocketDelegate {
    
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func receivedUserCount(_ count: Int) {
        peopleButton.setTitle("\(count)", for: .normal)
    }
    
    func pollStarted(_ poll: Poll) {
        // TODO
    }
    
    func pollEnded(_ poll: Poll) { }
    
    func receivedResults(_ currentState: CurrentState) { }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) { }

    // MARK: Helpers
    func emitAnswer(answer: Answer) {
        let data: [String:Any] = [
            RequestKeys.googleIdKey: User.currentUser?.id,
            RequestKeys.pollKey: answer.pollId,
            RequestKeys.choiceKey: answer.choice,
            RequestKeys.textKey: answer.text
        ]
        socket.socket.emit(Routes.tally, data)
    }
    
}
