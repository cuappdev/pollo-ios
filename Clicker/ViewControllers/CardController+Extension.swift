//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import UIKit

extension CardController: StartPollDelegate {
    func startPoll(text: String, type: QuestionType, options: [String], isShared: Bool) {
        // TODO
    }
}

extension CardController: EndPollDelegate {
    func endedPoll() {
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
