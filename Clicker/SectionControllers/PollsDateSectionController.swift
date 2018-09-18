//
//  PollsDateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollsDateSectionControllerDelegate {
    
    func pollsDateSectionControllerSwitchToHorizontalWith(index: Int)
    
}

class PollsDateSectionController: ListSectionController {
    
    // MARK: - Data Vars
    var pollsDateModel: PollsDateModel!
    var delegate: PollsDateSectionControllerDelegate!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 54
    
    init(delegate: PollsDateSectionControllerDelegate) {
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
        cell.configure(for: pollsDateModel)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pollsDateModel = object as? PollsDateModel
    }
    
    override func didSelectItem(at index: Int) {
        delegate.pollsDateSectionControllerSwitchToHorizontalWith(index: index)
    }
    
}
