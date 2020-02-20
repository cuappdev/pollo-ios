//
//  EmptyStateSectionController.swift
//  Pollo
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

protocol PollSectionControllerDelegate: class {
    
    var role: UserRole { get }
    var isConnected: Bool { get }

    func pollSectionControllerDidEditPoll(sectionController: PollSectionController, poll: Poll)
    func pollSectionControllerDidEndPoll(sectionController: PollSectionController, poll: Poll)
    func pollSectionControllerDidShareResultsForPoll(sectionController: PollSectionController, poll: Poll)
    func pollSectionControllerDidSubmitChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll)
}

class PollSectionController: ListSectionController {
    
    var delegate: PollSectionControllerDelegate!
    var poll: Poll!
    
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

    var isConnected: Bool {
        return delegate.isConnected
    }
    
    func cardCellDidSubmitChoice(cardCell: CardCell, choice: String, index: Int?) {
        if let index = index {
            poll.updateSelected(mcChoice: intToMCOption(index), choice: choice)
        }
        delegate.pollSectionControllerDidSubmitChoiceForPoll(sectionController: self, choice: choice, poll: poll)
    }
    
    func cardCellDidEndPoll(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidEndPoll(sectionController: self, poll: poll)
    }
    
    func cardCellDidShareResults(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidShareResultsForPoll(sectionController: self, poll: poll)
    }

    func cardCellDidEditPoll(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidEditPoll(sectionController: self, poll: poll)
    }

}
