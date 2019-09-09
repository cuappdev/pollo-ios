//
//  MCChoiceSectionController.swift
//  Pollo
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol MCChoiceSectionControllerDelegate {
    var pollState: PollState { get }
    
    func mcChoiceSectionControllerWasSelected(sectionController: MCChoiceSectionController)
}

class MCChoiceSectionController: ListSectionController {
    
    var choiceModel: MCChoiceModel!
    var delegate: MCChoiceSectionControllerDelegate!
    
    init(delegate: MCChoiceSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = LayoutConstants.mcOptionCellHeight
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MCChoiceCell.self, for: self, at: index) as! MCChoiceCell
        cell.configure(with: choiceModel, pollState: delegate.pollState, delegate: self)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        choiceModel = object as? MCChoiceModel
    }
    
}

extension MCChoiceSectionController: MCChoiceCellDelegate {
    
    func mcChoiceCellWasSelected() {
        choiceModel.isSelected = true
        delegate.mcChoiceSectionControllerWasSelected(sectionController: self)
    }
    
}
