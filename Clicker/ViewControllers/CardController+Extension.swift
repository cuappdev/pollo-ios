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
                return pollsDateArray[currentIndex].polls
            } else {
                return [EmptyStateModel(userRole: userRole)]
            }
        default:
            return pollsDateArray.map({ pollsDateModel -> PollDateModel in
                let latestPoll = pollsDateModel.polls[pollsDateModel.polls.count - 1]
                return PollDateModel(date: pollsDateModel.date, poll: latestPoll)
            })
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Poll {
            return PollSectionController()
        } else if object is PollDateModel {
            return PollDateSectionController(delegate: self)
        } else {
            return EmptyStateSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CardController: PollDateSectionControllerDelegate {
    
    var role: UserRole {
        return userRole
    }
    
}

extension CardController: StartPollDelegate {
    
    func startPoll(text: String, type: QuestionType, options: [String], isShared: Bool) {
        // TODO
    }

}

extension CardController: AskedCardDelegate {
    
    func askedCardDidEndPoll() {
        createPollButton.isUserInteractionEnabled = true
    }

}

extension CardController: NameViewDelegate {
    
    func nameViewDidUpdateSessionName() {
        navigationTitleView.updateNameAndCode(name: session.name, code: session.code)
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
    
}
