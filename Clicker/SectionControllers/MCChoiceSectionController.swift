//
//  MCChoiceSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol MCChoiceSectionControllerDelegate {
    var cardControllerState: CardControllerState { get }
    var pollState: PollState { get }
    
    func mcChoiceSectionControllerWasSelected(sectionController: MCChoiceSectionController)
}

class MCChoiceSectionController: ListSectionController {
    
    var delegate: MCChoiceSectionControllerDelegate!
    var choiceModel: MCChoiceModel!
    
    init(delegate: MCChoiceSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = delegate.cardControllerState == .horizontal
            ? LayoutConstants.horizontalOptionCellHeight
            : LayoutConstants.verticalOptionCellHeight
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
