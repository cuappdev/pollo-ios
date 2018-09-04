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
    
    // MARK: these refrences must be passed to each cell in the section
    var session: Session!
    var userRole: UserRole!
    var socket: Socket!
    var askedCardDelegate: AskedCardDelegate!
    
    
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
            cell.delegate = askedCardDelegate
            socket.addDelegate(cell)
            cell.poll = poll
            cell.cardType = poll.state
            cell.configure()
            return cell
        default:
            let cell = collectionContext?.dequeueReusableCell(of: AnswerCard.self, for: self, at: index) as! AskedCard
            cell.socket = socket
            cell.delegate = askedCardDelegate
            socket.addDelegate(cell)
            cell.poll = poll
            cell.cardType = poll.state
            cell.configure()
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        poll = object as? Poll
    }
        
}
