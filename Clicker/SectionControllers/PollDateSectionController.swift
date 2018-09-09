//
//  PollDateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollDateSectionControllerDelegate {
    var cardControllerState: CardControllerState { get }
    var role: UserRole { get }
    func switchToHorizontalWith(index: Int)
}

enum PollDateSectionControllerItemType {
    case date
    case card
}

class PollDateSectionController: ListSectionController {
    
    // MARK: - Data Vars
    var pollDateModel: PollDateModel!
    var delegate: PollDateSectionControllerDelegate!
    var itemTypes: [PollDateSectionControllerItemType]!
    
    // MARK: - Constants
    let dateCellHeight: CGFloat = 50
    
    init(delegate: PollDateSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func numberOfItems() -> Int {
        return itemTypes.count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.insetContainerSize else {
            return .zero
        }
        let itemType = itemTypes[index]
        switch itemType {
        case .date:
            return CGSize(width: containerSize.width, height: dateCellHeight)
        case .card:
            let cardCellHeight = calculateCardCellHeight(poll: pollDateModel.poll, userRole: delegate.role)
            return CGSize(width: containerSize.width, height: cardCellHeight)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        let itemType = itemTypes[index]
        switch itemType {
        case .date:
            let dateCell = collectionContext?.dequeueReusableCell(of: DateCell.self, for: self, at: index) as! DateCell
            dateCell.configure(with: pollDateModel.date)
            dateCell.setNeedsUpdateConstraints()
            cell = dateCell
        case .card:
            let cardCell = collectionContext?.dequeueReusableCell(of: CardCell.self, for: self, at: index) as! CardCell
            cardCell.configure(with: self, poll: pollDateModel.poll, userRole: delegate.role)
            cardCell.setNeedsUpdateConstraints()
            cell = cardCell
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        if let object = object as? PollDateModel {
            pollDateModel = object
            itemTypes = [.date, .card]
        } else {
            itemTypes = []
        }
    }
    
    override func didSelectItem(at index: Int) {
        delegate.switchToHorizontalWith(index: pollDateModel.index)
    }
    
    // MARK: - Helpers
    private func calculateCardCellHeight(poll: Poll, userRole: UserRole) -> CGFloat {
        let topBottomHamburgerCellHeight = LayoutConstants.hamburgerCardCellHeight * 2
        let questionCellHeight = LayoutConstants.verticalQuestionCellHeight
        let pollOptionsCellVerticalPadding = LayoutConstants.pollOptionsVerticalPadding * 2
        let numOptions = min(poll.options.count, 6)
        let pollOptionsCellHeight = LayoutConstants.verticalOptionCellHeight * CGFloat(numOptions) + pollOptionsCellVerticalPadding
        let miscellaneousCellHeight = LayoutConstants.pollMiscellaneousCellHeight
        let hasButtonCell = userRole == .admin && (poll.state == .live || poll.state == .ended)
        let pollButtonCellHeight = hasButtonCell ? LayoutConstants.pollButtonCellHeight : 0
        return topBottomHamburgerCellHeight + questionCellHeight + pollOptionsCellHeight + miscellaneousCellHeight + pollButtonCellHeight
    }
}

extension PollDateSectionController: CardCellDelegate {
    
    var cardControllerState: CardControllerState {
        return delegate.cardControllerState
    }
    
    var userRole: UserRole {
        return delegate.role
    }
    
    func cardCellDidEndPoll(cardCell: CardCell, poll: Poll) {}
    
    func cardCellDidShareResults(cardCell: CardCell, poll: Poll) {}
    
}
