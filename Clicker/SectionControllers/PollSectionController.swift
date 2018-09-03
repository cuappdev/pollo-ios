//
//  EmptyStateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit


class PollSectionController: ListSectionController {
    
    // MARK: todo implement
    var session: Session!
    var userRole: UserRole!
    var socket: Socket!
    var endPollDelegate: EndPollDelegate!
    
    var poll: Poll!
    let widthScaleFactor: CGFloat = 0.9
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width * widthScaleFactor, height: containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch (userRole) {
        case .admin:
            let cell = collectionContext?.dequeueReusableCell(of: AskedCard.self, for: self, at: index) as! AskedCard
            cell.socket = socket
            socket.addDelegate(cell)
            cell.poll = poll
            cell.endPollDelegate = endPollDelegate
            cell.cardType = getCardType(from: poll)
            cell.configure()
            return cell
        default:
            let cell = collectionContext?.dequeueReusableCell(of: AnswerCard.self, for: self, at: index) as! AskedCard
            cell.socket = socket
            socket.addDelegate(cell)
            cell.poll = poll
            cell.cardType = getCardType(from: poll)
            cell.configure()
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        poll = object as? Poll
    }
        
    // MARK: Helpers
    func getCardType(from poll: Poll) -> CardType {
        if (poll.isLive) {
            return .live
        } else if (poll.isShared) {
            return .shared
        } else {
            return .ended
        }
    }
}
