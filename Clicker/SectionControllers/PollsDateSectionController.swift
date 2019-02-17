//
//  PollsDateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollsDateSectionControllerDelegate: class {
    
    func pollsDateSectionControllerDidTap(for pollsDateModel: PollsDateModel)
    
}

class PollsDateSectionController: ListSectionController {
    
    // MARK: - Data Vars
    var pollsDateModel: PollsDateModel!
    var isLastCell: Bool!
    weak var delegate: PollsDateSectionControllerDelegate?
    
    // MARK: - Constants
    let cellHeight: CGFloat = 54.75
    
    init(delegate: PollsDateSectionControllerDelegate, isLast: Bool) {
        isLastCell = isLast
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollsDateCell.self, for: self, at: index) as! PollsDateCell
        cell.configure(for: pollsDateModel, isNotLast: !isLastCell)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pollsDateModel = object as? PollsDateModel
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.pollsDateSectionControllerDidTap(for: pollsDateModel)
    }
    
}
