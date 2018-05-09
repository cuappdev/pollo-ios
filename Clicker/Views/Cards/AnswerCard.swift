//
//  AnswerCard.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class AnswerCard: UICollectionViewCell, CardDelegate, SocketDelegate {
    
    var freeResponses: [String]!
    
    var cardView: CardView!
    
    var choice: Int?
    var poll: Poll!
    var socket: Socket!
    var cardType: CardType!
    var cardHeightConstraint: Constraint!
    var expandCardDelegate: ExpandCardDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clickerDeepBlack
        setup()
    }
    
    func configure() {
        cardView.questionLabel.text = poll.text
        cardView.poll = poll
        cardView.cardType = cardType
        cardView.configure()
        cardView.setupCard()
    }
    
    func setup() {
        cardView = CardView(frame: .zero, userRole: .member, cardDelegate: self)
        cardView.highlightColor = .clickerHalfGreen
        addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Actions
    @objc func seeAllAction() {
        print("see all")
    }
    
    // MARK: CARD DELEGATE
    func questionBtnPressed() { }
    
    func emitTally(answer: [String : Any]) {
        socket.socket.emit("server/poll/tally", answer)
    }
    
    // MARK: SOCKET DELEGATE
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func receivedUserCount(_ count: Int) { }
    
    func pollStarted(_ poll: Poll) { }
    
    func pollEnded(_ poll: Poll) {
        cardView.poll.isLive = false
        DispatchQueue.main.async { self.cardView.resultsTableView.reloadData() }
        cardView.cardType = .ended
        cardView.setupEnded()
    }
    
    func receivedResults(_ currentState: CurrentState) {
        cardView.poll.isShared = true
        cardView.poll.results = currentState.results
        cardView.totalNumResults = currentState.getTotalCount()
        cardView.totalResultsLabel.text = "\(cardView.totalNumResults) votes"
        DispatchQueue.main.async { self.cardView.resultsTableView.reloadData() }
        cardView.cardType = .shared
        cardView.setupShared()
    }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
