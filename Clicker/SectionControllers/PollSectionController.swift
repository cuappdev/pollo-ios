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
    
    var role: UserRole { get }

    func pollSectionControllerDidSubmitChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll)
    func pollSectionControllerDidUpvote(sectionController: PollSectionController, answerId: String)
    func pollSectionControllerDidEndPoll(sectionController: PollSectionController, poll: Poll)
    func pollSectionControllerDidShareResultsForPoll(sectionController: PollSectionController, poll: Poll)
}

class PollSectionController: ListSectionController {
    
    var poll: Poll!
    var delegate: PollSectionControllerDelegate!
    
    init(delegate: PollSectionControllerDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.insetContainerSize else {
            return .zero
        }
        return containerSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: CardCell.self, for: self, at: index) as! CardCell
        cell.configure(with: self, poll: poll, userRole: delegate.role)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        poll = object as? Poll
    }

    // MARK: - Updates
    func update(with poll: Poll) {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? CardCell else { return }
        cell.update(with: poll)
    }
        
}

extension PollSectionController: CardCellDelegate {
    
    var userRole: UserRole {
        return delegate.role
    }
    
    func cardCellDidSubmitChoice(cardCell: CardCell, choice: String) {
        poll.updateSelected(mcChoice: choice)
        delegate.pollSectionControllerDidSubmitChoiceForPoll(sectionController: self, choice: choice, poll: poll)
    }

    func cardCellDidUpvote(cardCell: CardCell, answerId: String) {
        delegate.pollSectionControllerDidUpvote(sectionController: self, answerId: answerId)
    }
    
    func cardCellDidEndPoll(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidEndPoll(sectionController: self, poll: poll)
    }
    
    func cardCellDidShareResults(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidShareResultsForPoll(sectionController: self, poll: poll)
    }

}
