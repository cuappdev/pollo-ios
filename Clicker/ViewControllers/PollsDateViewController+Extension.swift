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
        let cardContorller = CardController(pollsDateModel: pollsDateModel, session: session, userRole: userRole)
        self.navigationController?.pushViewController(cardContorller, animated: false)
    }
    
}

extension PollsDateViewController: PollBuilderViewControllerDelegate {
    
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState) {

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
