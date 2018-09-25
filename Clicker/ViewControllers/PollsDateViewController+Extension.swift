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

extension PollsDateViewController: CardControllerDelegate {
    
    func cardControllerWillDisappear(with pollsDateModel: PollsDateModel) {
        if let indexOfPollsDateModel = pollsDateArray.firstIndex(where: { $0.date == pollsDateModel.date }) {
            pollsDateArray[indexOfPollsDateModel] = pollsDateModel
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    func cardControllerDidStartNewPoll(poll: Poll) {
        let newPollsDateModel = PollsDateModel(date: getTodaysDate(), polls: [poll])
        pollsDateArray.append(newPollsDateModel)
        let cardController = CardController(delegate: self, pollsDateModel: newPollsDateModel, session: session, socket: socket, userRole: userRole)
        self.navigationController?.pushViewController(cardController, animated: false)
    }
    
}

extension PollsDateViewController: PollSectionControllerDelegate {
    
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
        emitAnswer(answer: answer, message: Routes.serverTally)
    }
    
    func pollSectionControllerDidUpvoteChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll) {
        // You can only upvote for FR questions
        if poll.questionType == .multipleChoice { return }
        let answer = Answer(text: choice, choice: choice, pollId: poll.id)
        emitAnswer(answer: answer, message: Routes.serverUpvote)
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

extension PollsDateViewController: PollsDateSectionControllerDelegate {
    
    func pollsDateSectionControllerDidTap(for pollsDateModel: PollsDateModel) {
        let cardController = CardController(delegate: self, pollsDateModel: pollsDateModel, session: session, socket: socket, userRole: userRole)
        self.navigationController?.pushViewController(cardController, animated: false)
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
        let newPoll = Poll(text: text, questionType: type, options: options, results: results, state: state, answer: nil)
        appendPoll(poll: newPoll)
        adapter.performUpdates(animated: false, completion: nil)
        if let lastPollsDateModel = pollsDateArray.last {
            let cardController = CardController(delegate: self, pollsDateModel: lastPollsDateModel, session: session, socket: socket, userRole: userRole)
            self.navigationController?.pushViewController(cardController, animated: false)
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
        navigationTitleView.updateNameAndCode(name: session.name, code: session.code)
    }
    
}

extension PollsDateViewController: SocketDelegate {
    
    func sessionConnected() {}
    
    func sessionDisconnected() {}
    
    func receivedUserCount(_ count: Int) {
        peopleButton.setTitle("\(count)", for: .normal)
    }
    
    func pollStarted(_ poll: Poll) {
        appendPoll(poll: poll)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func pollEnded(_ poll: Poll, userRole: UserRole) {

    }
    
    func receivedResults(_ currentState: CurrentState) {

    }
    
    func updatedTally(_ currentState: CurrentState) {
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
    
    func endPoll(poll: Poll) {
        updateLatestPoll(with: poll)
    }
    
    func updatedPollOptions(for poll: Poll, currentState: CurrentState) -> [String] {
        return []
    }
    
    func updateWithCurrentState(currentState: CurrentState, pollState: PollState?) {
       
    }
    
    func updateLatestPoll(with poll: Poll) {
        
    }
    
    func getLatestPoll() -> Poll? {
        guard let latestPollsDateModel = pollsDateArray.last else { return nil }
        return latestPollsDateModel.polls.last
    }
    
}
