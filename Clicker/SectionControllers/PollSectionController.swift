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
    
    func configureWith(session: Session, userRole: UserRole, askedCardDelegate: AskedCardDelegate, socket: Socket)
    {
        self.session = session
        self.userRole = userRole
        self.askedCardDelegate = askedCardDelegate
        self.socket = socket
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
            socket.addDelegate(cell)
            cell.configureWith(socket: socket, delegate: askedCardDelegate, poll: poll)
            return cell
        default:
            let cell = collectionContext?.dequeueReusableCell(of: AnswerCard.self, for: self, at: index) as! AnswerCard
            cell.socket = socket
            socket.addDelegate(cell)
            cell.configureWith(socket: socket, poll: poll)
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        poll = object as? Poll
    }
        
}
