//
//  EmptyStateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

protocol PollSectionControllerDelegate {
    
    var cardControllerState: CardControllerState { get }
    
}

class PollSectionController: ListSectionController {
    
    // MARK: these refrences must be passed to each cell in the section
    var session: Session!
    var userRole: UserRole!
    var socket: Socket!
    var askedCardDelegate: AskedCardDelegate!
    
    var poll: Poll!
    var delegate: PollSectionControllerDelegate!
    let widthScaleFactor: CGFloat = 0.9
    
    init(delegate: PollSectionControllerDelegate) {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width * widthScaleFactor, height: containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: CardCell.self, for: self, at: index) as! CardCell
        cell.configure(with: self, poll: poll)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        poll = object as? Poll
    }
        
}

extension PollSectionController: CardCellDelegate {
    
    var cardControllerState: CardControllerState {
        return delegate.cardControllerState
    }
    
}
