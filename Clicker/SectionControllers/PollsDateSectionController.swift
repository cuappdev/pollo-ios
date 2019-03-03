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
    weak var delegate: PollsDateSectionControllerDelegate?
    
    // MARK: - Constants
    let cellHeight: CGFloat = 48
    let verticalPadding: CGFloat = 16
    let cellCornerRadius: CGFloat = 5
    
    init(delegate: PollsDateSectionControllerDelegate) {
        self.delegate = delegate
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: verticalPadding, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.insetContainerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollsDateCell.self, for: self, at: index) as! PollsDateCell
        cell.configure(for: pollsDateModel)
        cell.setNeedsUpdateConstraints()
        cell.layer.cornerRadius = cellCornerRadius
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pollsDateModel = object as? PollsDateModel
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.pollsDateSectionControllerDidTap(for: pollsDateModel)
    }
    
}
