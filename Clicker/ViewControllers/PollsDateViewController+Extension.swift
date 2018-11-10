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
        // Want to display latest PollsDateModels on top
        return pollsDateArray.reversed()
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
    
    func cardControllerWillDisappear(with pollsDateModel: PollsDateModel, numberOfPeople: Int) {
        self.numberOfPeople = numberOfPeople
        peopleButton.setTitle("\(numberOfPeople)", for: .normal)
        peopleButton.sizeToFit()
        if let indexOfPollsDateModel = pollsDateArray.firstIndex(where: { $0.date == pollsDateModel.date }) {
            pollsDateArray[indexOfPollsDateModel] = PollsDateModel(date: pollsDateModel.date, polls: pollsDateModel.polls)
            adapter.performUpdates(animated: false, completion: nil)
        }
        self.socket.updateDelegate(self)
    }
    
    func cardControllerDidStartNewPoll(poll: Poll) {
        let newPollsDateModel = PollsDateModel(date: getTodaysDate(), polls: [poll])
        pollsDateArray.append(newPollsDateModel)
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
        socket.socket.emit(Routes.serverStart, socketQuestion)
        let results = buildEmptyResultsFromOptions(options: options, questionType: type)
        let newPoll = Poll(text: text, questionType: type, options: options, results: results, state: state, selectedMCChoice: nil)
        appendPoll(poll: newPoll)
        adapter.performUpdates(animated: false, completion: nil)
        if let lastPollsDateModel = pollsDateArray.last {
            let cardController = CardController(delegate: self, pollsDateModel: lastPollsDateModel, session: session, socket: socket, userRole: userRole, numberOfPeople: numberOfPeople)
            self.navigationController?.pushViewController(cardController, animated: true)
        }
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
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

extension PollsDateViewController: NameViewDelegate {
    
    func nameViewDidUpdateSessionName() {
        navigationTitleView.configure(primaryText: session.name, secondaryText: "Code: \(session.code)")
    }
    
}

extension PollsDateViewController: NavigationTitleViewDelegate {

    func navigationTitleViewNavigationButtonTapped() {
        guard userRole == .admin else { return }
        let pollsDateAttendanceArray = pollsDateArray.map { PollsDateAttendanceModel(model: $0, isSelected: false) }
        GetMembers(id: session?.id ?? -1).make()
            .done { (users) in
                let groupControlsVC = GroupControlsViewController(session: self.session, pollsDateAttendanceArray: pollsDateAttendanceArray.reversed(), numMembers: users.count)
                self.navigationController?.pushViewController(groupControlsVC, animated: true)
            }.catch { (error) in
                print(error)
        }
    }

}

extension PollsDateViewController: SocketDelegate {
    
    func sessionConnected() {}
    
    func sessionDisconnected() {}
    
    func receivedUserCount(_ count: Int) {
        numberOfPeople = count
        peopleButton.setTitle("\(count)", for: .normal)
        peopleButton.sizeToFit()
    }
    
    func pollStarted(_ poll: Poll, userRole: UserRole) {
        if let lastPollsDateModel = pollsDateArray.last {
            if lastPollsDateModel.polls.contains(where: { otherPoll -> Bool in
                return otherPoll.id == poll.id
            }) || lastPollsDateModel.polls.last?.state == .live { return }
        }
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
        switch poll.questionType {
        case .freeResponse:
            let updatedPoll = Poll(id: latestPoll.id, text: latestPoll.text, questionType: latestPoll.questionType, options: latestPoll.options, results: latestPoll.results, state: .ended, selectedMCChoice: latestPoll.selectedMCChoice)
            updateLatestPoll(with: updatedPoll)
        case .multipleChoice:
            updateLatestPoll(with: poll)
        }
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func receivedResults(_ currentState: CurrentState) {
        guard let latestPoll = getLatestPoll() else { return }
        // Free Response receives results in live state
        let pollState: PollState = latestPoll.questionType == .multipleChoice ? .shared : latestPoll.state
        updateWithCurrentState(currentState: currentState, pollState: pollState)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func receivedResultsLive(_ currentState: CurrentState) {
        guard let _ = getLatestPoll() else { return }
        updateWithCurrentState(currentState: currentState, pollState: .live)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func updatedTally(_ currentState: CurrentState) {
        updateWithCurrentState(currentState: currentState, pollState: nil)
        adapter.performUpdates(animated: false, completion: nil)
    }

    func updatedTallyLive(_ currentState: CurrentState) {
        updateWithCurrentState(currentState: currentState, pollState: .live)
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
        socket.socket.emit(Routes.serverEnd, [])
    }
    
    func emitShareResults() {
        socket.socket.emit(Routes.serverShare, [])
    }
    
    func appendPoll(poll: Poll) {
        let todaysDate = getTodaysDate()
        if let lastPollDateModel = pollsDateArray.last {
            if lastPollDateModel.date == todaysDate {
                var updatedPolls = lastPollDateModel.polls
                updatedPolls.append(poll)
                let updatedPollsDateModel = PollsDateModel(date: lastPollDateModel.date, polls: updatedPolls)
                pollsDateArray[pollsDateArray.count - 1] = updatedPollsDateModel
                return
            }
        }
        let newPollsDate = PollsDateModel(date: todaysDate, polls: [poll])
        pollsDateArray.append(newPollsDate)
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
        let updatedPoll = Poll(poll: latestPoll, currentState: currentState, updatedPollState: updatedPollState)
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
            poll.selectedMCChoice = pollsDateArray.last?.polls.last?.selectedMCChoice
            pollsDateArray[pollsDateArray.count - 1].polls[todayPolls.count - 1] = poll
        }
    }
    
    func getLatestPoll() -> Poll? {
        return pollsDateArray.last?.polls.last
    }
    
}
