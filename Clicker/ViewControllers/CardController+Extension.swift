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
            return pollsDateArray.compactMap({ pollsDateModel -> PollDateModel? in
                if let latestPoll = pollsDateModel.polls.last {
                    collectionView.isScrollEnabled = true
                    return PollDateModel(date: pollsDateModel.date, poll: latestPoll)
                }
                return nil
            })
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Poll {
            let pollSectionController = PollSectionController()
            pollSectionController.session = session
            pollSectionController.userRole = userRole
            pollSectionController.socket = socket
            pollSectionController.askedCardDelegate = self
            return pollSectionController
        } else if object is PollDateModel {
            return PollDateSectionController(delegate: self)
        } else {
            let emptyStateController = EmptyStateSectionController()
            emptyStateController.session = session
            emptyStateController.userRole = userRole
            emptyStateController.nameViewDelegate = self
            return emptyStateController
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
        let newPoll = Poll(text: text, options: options, type: type, state: state)
        appendPoll(poll: newPoll)
        adapter.performUpdates(animated: true, completion: nil)
        let lastIndexPath = IndexPath(item: 0, section: 0)//pollsDateArray[currentIndex].polls.count-1)
        self.collectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func appendPoll(poll: Poll) {
        print(pollsDateArray)
        let date = "today"
        let newPollDate = PollsDateModel(date: date, polls: [poll])
        
        guard let _ = pollsDateArray else {
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
