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
    func pollSectionControllerDidUpvoteChoiceForPoll(sectionController: PollSectionController, choice: String, poll: Poll)
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
        
}

extension PollSectionController: CardCellDelegate {
    
    var userRole: UserRole {
        return delegate.role
    }
    
    func cardCellDidSubmitChoice(cardCell: CardCell, choice: String) {
        poll.answer = choice
        delegate.pollSectionControllerDidSubmitChoiceForPoll(sectionController: self, choice: choice, poll: poll)
    }
    
    func cardCellDidUpvoteChoice(cardCell: CardCell, choice: String) {
        increaseCountForChoice(choice: choice)
        delegate.pollSectionControllerDidUpvoteChoiceForPoll(sectionController: self, choice: choice, poll: poll)
    }
    
    func cardCellDidEndPoll(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidEndPoll(sectionController: self, poll: poll)
    }
    
    func cardCellDidShareResults(cardCell: CardCell, poll: Poll) {
        delegate.pollSectionControllerDidShareResultsForPoll(sectionController: self, poll: poll)
    }
    
    // MARK: - Helpers
    private func increaseCountForChoice(choice: String) {
        if let choiceJSON = poll.results[choice], let count = choiceJSON[ParserKeys.countKey].int {
            poll.results[choice] = [
                ParserKeys.textKey: choice,
                ParserKeys.countKey: count + 1
            ]
        }
    }
}
