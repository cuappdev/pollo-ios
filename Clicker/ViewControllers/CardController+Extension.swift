//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension CardController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - COLLECTIONVIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == verticalCollectionView) {
            return datePollsArr.count
        } else { // mainCollectionView
            return currentPolls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == verticalCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateIdentifier, for: indexPath) as! CardDateCell
            let poll = datePollsArr[indexPath.item].1.first
            cell.poll = poll
            cell.date = datePollsArr[indexPath.item].0
            cell.userRole = userRole
            cell.cardType = getCardType(from: poll!)
            cell.configure()
            return cell
        }
        // mainCollectionView
        switch (userRole) {
        case .admin:
            let poll = currentPolls[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: askedIdentifer, for: indexPath) as! AskedCard
            cell.socket = socket
            socket.addDelegate(cell)
            cell.poll = poll
            cell.endPollDelegate = self
            cell.cardType = getCardType(from: poll)
            cell.configure()
            return cell
        default:
            let poll = currentPolls[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerIdentifier, for: indexPath) as! AnswerCard
            cell.socket = socket
            socket.addDelegate(cell)
            cell.poll = poll
            cell.cardType = getCardType(from: poll)
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView == mainCollectionView) {
            // UPDATE COUNT LABEL
            let countString = "\(indexPath.item + 1)/\(currentPolls.count)"
            countLabel.attributedText = getCountLabelAttributedString(countString)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == mainCollectionView) {
            return CGSize(width: view.frame.width * 0.9, height: mainCollectionView.frame.height)
        } else {
            return CGSize(width: view.frame.width * 0.76, height: 440)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == verticalCollectionView) {
            currentDatePollsIndex = indexPath.item
            currentPolls = datePollsArr[currentDatePollsIndex].1
            revertToHorizontal()
        }
    }
    
}

extension CardController: StartPollDelegate {
    func startPoll(text: String, type: String, options: [String], isShared: Bool) {
        // EMIT START QUESTION
        let socketQuestion: [String:Any] = [
            "text": text,
            "type": type,
            "options": options,
            "shared": isShared
        ]
        socket.socket.emit("server/poll/start", with: [socketQuestion])
        let questionType: QuestionType = (type == "MULTIPLE_CHOICE") ? .multipleChoice : .freeResponse
        let newPoll = Poll(text: text, options: options, type: questionType, isLive: true, isShared: isShared)
        let arrEmpty = (datePollsArr.count == 0)
        appendPoll(poll: newPoll)
        // DISABLE CREATE POLL BUTTON
        createPollButton.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            if (!arrEmpty) {
                self.mainCollectionView.reloadData()
            }
            let lastIndexPath = IndexPath(item: self.currentPolls.count - 1, section: 0)
            self.mainCollectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension CardController: EndPollDelegate {
    func endedPoll() {
        createPollButton.isUserInteractionEnabled = true
    }
}

extension CardController: NameViewDelegate {
    func nameViewDidUpdateSessionName() {
        navigationTitleView.updateViews(name: session.name, code: session.code)
    }
}

extension CardController: SocketDelegate {
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func receivedUserCount(_ count: Int) {
        peopleButton.setTitle("\(count)", for: .normal)
    }
    
    func pollStarted(_ poll: Poll) {
        if (userRole == .member) {
            let arrEmpty = (datePollsArr.count == 0)
            appendPoll(poll: poll)
            if (!arrEmpty) {
                self.mainCollectionView.reloadData()
                let lastIndexPath = IndexPath(item: self.currentPolls.count - 1, section: 0)
                self.mainCollectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func pollEnded(_ poll: Poll) { }
    
    func receivedResults(_ currentState: CurrentState) { }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) { }
}
