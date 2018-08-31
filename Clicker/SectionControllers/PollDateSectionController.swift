//
//  PollDateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum PollDateSectionControllerItemType {
    case date
    case card
}

class PollDateSectionController: ListSectionController {
    
    var pollDateModel: PollDateModel!
    var itemTypes: [PollDateSectionControllerItemType]!
    let dateCellHeight: CGFloat = 50
    let cardCellHeight: CGFloat = 300
    
    // MARK: - ListSectionController overrides
    override func numberOfItems() -> Int {
        return itemTypes.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.insetContainerSize else {
            return .zero
        }
        let itemType = itemTypes[index]
        switch (itemType) {
        case .date:
            return CGSize(width: containerSize.width, height: dateCellHeight)
        case .card:
            return CGSize(width: containerSize.width, height: cardCellHeight)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        let itemType = itemTypes[index]
        switch (itemType) {
        case .date:
            let dateCell = collectionContext?.dequeueReusableCell(of: DateCell.self, for: self, at: index) as! DateCell
            dateCell.configure(with: pollDateModel.date)
            dateCell.setNeedsUpdateConstraints()
            cell = dateCell
            break
        case .card:
            let cardCell = collectionContext?.dequeueReusableCell(of: CardCell.self, for: self, at: index) as! CardCell
            cardCell.configure(for: pollDateModel.poll)
            cardCell.setNeedsUpdateConstraints()
            cell = cardCell
            break
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
}
