//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension CardController {
    
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
