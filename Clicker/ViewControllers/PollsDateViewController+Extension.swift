//
//  PollsDateViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 9/23/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SwiftyJSON
import UIKit

extension PollsDateViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if pollsDateArray.isEmpty {
            let type: EmptyStateType = .cardController(userRole: userRole)
            return [EmptyStateModel(type: type)]
        }
        return pollsDateArray
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is PollsDateModel {
            let pollsDateSectionController = PollsDateSectionController(delegate: self)
            return pollsDateSectionController
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

extension PollsDateViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomModalPresentationController(presented: presented, presenting: presenting, style: .upToStatusBar)
    }
}

extension PollsDateViewController: CardControllerDelegate {
    
    func receivedResults(_ poll: Poll) {
        adapter.performUpdates(animated: false, completion: nil)
    }

    func updatedTally(_ poll: Poll) {
        adapter.performUpdates(animated: false, completion: nil)
    }

    func cardControllerWillDisappear(with pollsDateModel: PollsDateModel, numberOfPeople: Int) {
        self.numberOfPeople = numberOfPeople
        if let indexOfPollsDateModel = pollsDateArray.firstIndex(where: { $0.date == pollsDateModel.date }) {
            pollsDateArray[indexOfPollsDateModel] = PollsDateModel(date: pollsDateModel.date, polls: pollsDateModel.polls)
            adapter.performUpdates(animated: false, completion: nil)
        }
        self.socket.updateDelegate(self)
    }
    
    func cardControllerDidStartNewPoll(poll: Poll) {
        let newPollsDateModel = PollsDateModel(date: Date().secondsString, polls: [poll])
        pollsDateArray.insert(newPollsDateModel, at: 0)
        let cardController = CardController(delegate: self, pollsDateModel: newPollsDateModel, session: session, socket: socket, userRole: userRole, numberOfPeople: numberOfPeople)
        self.navigationController?.pushViewController(cardController, animated: true)
    }

}

extension PollsDateViewController: PollsDateSectionControllerDelegate {
    
    func pollsDateSectionControllerDidTap(for pollsDateModel: PollsDateModel) {
        let cardController = CardController(delegate: self, pollsDateModel: pollsDateModel, session: session, socket: socket, userRole: userRole, numberOfPeople: numberOfPeople)
        self.navigationController?.pushViewController(cardController, animated: true)
    }
    
}

extension PollsDateViewController: PollBuilderViewControllerDelegate {
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState, answerChoices: [PollResult], correctAnswer: String?, shouldPopViewController: Bool) {
        createPollButton.isUserInteractionEnabled = false
        createPollButton.isHidden = true

        let newPoll = Poll(text: text, answerChoices: answerChoices, type: type, correctAnswer: correctAnswer, userAnswers: [:], state: .live)
        newPoll.createdAt = Date().secondsString

        let answerChoicesDict = answerChoices.compactMap { $0.dictionary }

        let correct = correctAnswer ?? ""

        let newPollDict: [String: Any] = [
            "text": text,
            "answerChoices": answerChoicesDict,
            "state": "live",
            "correctAnswer": correct,
            "userAnswers": [String: [PollChoice]](),
            "type": type.rawValue
        ]

        socket.socket.emit(Routes.serverStart, newPollDict)
        appendPoll(poll: newPoll)
        adapter.performUpdates(animated: false, completion: nil)
        if let firstPollsDateModel = pollsDateArray.first {
            let cardController = CardController(delegate: self, pollsDateModel: firstPollsDateModel, session: session, socket: socket, userRole: userRole, numberOfPeople: numberOfPeople)
            self.navigationController?.pushViewController(cardController, animated: true)
        }
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension PollsDateViewController: NameViewDelegate {
    
    func nameViewDidUpdateSessionName() {
        navigationTitleView.configure(primaryText: session.name, secondaryText: "Code: \(session.code)")
    }
    
}

extension PollsDateViewController: NavigationTitleViewDelegate {

    func navigationTitleViewNavigationButtonTapped() {
        guard userRole == .admin else { return }
        let pollsDateAttendanceArray = pollsDateArray.map { PollsDateAttendanceModel(model: $0, isSelected: false) }
        getMembers(with: session?.id ?? -1).observe { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    let groupControlsVC = GroupControlsViewController(session: self.session, pollsDateAttendanceArray: pollsDateAttendanceArray, numMembers: response.data.count, delegate: self)
                    self.navigationController?.pushViewController(groupControlsVC, animated: true)
                case .error(let error):
                    print(error)
                    let alertController = self.createAlert(title: "Error", message: "Failed to load data. Try again!")
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

}

// MARK: - GroupControlsViewControllerDelegate
extension PollsDateViewController: GroupControlsViewControllerDelegate {

    func groupControlsViewControllerDidUpdateSession(_ session: Session) {
        self.session = session
    }

}

extension PollsDateViewController: SocketDelegate {

    func sessionConnected() {}
    
    func sessionDisconnected() {}

    func receivedFRFilter(_ pollFilter: PollFilter) { }

    func sessionErrored() {
        socket.socket.connect(timeoutAfter: 5) { [weak self] in
            guard let `self` = self else { return }
            let alertController = self.createAlert(title: "Error", message: "Could not join poll. Try joining again!", handler: { _ in
                self.goBack()
                self.socket.delegate = nil
            })
            if self.presentedViewController == nil {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func pollStarted(_ poll: Poll, userRole: UserRole) {
        appendPoll(poll: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func pollEnded(_ poll: Poll, userRole: UserRole) {
        guard let latestPoll = getLatestPoll() else { return }
        if userRole == .admin {
            latestPoll.id = poll.id
            updateLatestPoll(with: latestPoll)
            return
        }
        updateLatestPoll(with: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func pollDeleted(_ pollID: Int, userRole: UserRole) {
        for i in 0..<pollsDateArray.count {
            if let index = pollsDateArray[i].polls.firstIndex(where: { $0.id == pollID }) {
                var newPolls = pollsDateArray[i].polls.map { Poll(poll: $0, state: $0.state) }
                newPolls.remove(at: index)
                let newPollsDateModel = PollsDateModel(date: pollsDateArray[i].date, polls: newPolls)
                pollsDateArray[i] = newPollsDateModel
            }
        }
        removeEmptyModels()
        adapter.performUpdates(animated: false, completion: nil)
    }

    func pollDeletedLive() {
        for i in 0..<pollsDateArray.count {
            if let index = pollsDateArray[i].polls.firstIndex(where: { $0.state == .live }) {
                var newPolls = pollsDateArray[i].polls.map { Poll(poll: $0, state: $0.state) }
                newPolls.remove(at: index)
                let newPollsDateModel = PollsDateModel(date: pollsDateArray[i].date, polls: newPolls)
                pollsDateArray[i] = newPollsDateModel
            }
        }
        removeEmptyModels()
        adapter.performUpdates(animated: false, completion: nil)
    }

    func receivedResults(_ poll: Poll, userRole: UserRole) {
        // Free Response receives results in live state
        updateLatestPoll(with: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func receivedResultsLive(_ poll: Poll, userRole: UserRole) {
        guard getLatestPoll() != nil else { return }
        updateLatestPoll(with: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func updatedTally(_ poll: Poll, userRole: UserRole) {
        updateLatestPoll(with: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func updatedTallyLive(_ poll: Poll, userRole: UserRole) {
        updateLatestPoll(with: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    // MARK: Helpers
    
    func emitAnswer(pollChoice: PollChoice, message: String) {
        guard let pollChoiceDict = pollChoice.dictionary else { return }
        socket.socket.emit(message, pollChoiceDict)
    }

    func emitEndPoll() {
        socket.socket.emit(Routes.serverEnd, [])
    }
    
    func emitShareResults() {
        socket.socket.emit(Routes.serverShare, [])
    }
    
    func appendPoll(poll: Poll) {
        let todaysDate = Date()
        if let firstPollDateModel = pollsDateArray.first, firstPollDateModel.dateValue.isSameDay(as: todaysDate) {
            var updatedPolls = firstPollDateModel.polls
            updatedPolls.append(poll)
            let updatedPollsDateModel = PollsDateModel(date: firstPollDateModel.date, polls: updatedPolls)
            pollsDateArray[0] = updatedPollsDateModel
            return
        }
        let newPollsDate = PollsDateModel(date: todaysDate.secondsString, polls: [poll])
        pollsDateArray.insert(newPollsDate, at: 0)
    }

    func updateLatestPoll(with poll: Poll) {
        guard let latestPollsDateModel = pollsDateArray.first else { return }
        let todaysDate = Date()
        if !latestPollsDateModel.dateValue.isSameDay(as: todaysDate) {
            // User has no polls for today yet
            let todayPollsDateModel = PollsDateModel(date: todaysDate.secondsString, polls: [poll])
            pollsDateArray.insert(todayPollsDateModel, at: 0)
        } else {
            // User has polls for today, so just update latest poll for today
            let todayPolls = latestPollsDateModel.polls
            pollsDateArray[0].polls[todayPolls.count - 1] = poll
        }
    }
    
    func getLatestPoll() -> Poll? {
        return pollsDateArray.first?.polls.last
    }

    func removeEmptyModels() {
        let filteredModels = pollsDateArray.filter { $0.polls.count > 0 }
        pollsDateArray = filteredModels
        adapter.performUpdates(animated: true, completion: nil)
    }
    
}
