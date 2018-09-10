//
//  FRInputSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/10/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol FRInputSectionControllerDelegate {
    
    var cardControllerState: CardControllerState { get }
    var pollState: PollState { get }
    
}

class FRInputSectionController: ListSectionController {
    
    // MARK: - Data vars
    var delegate: FRInputSectionControllerDelegate!
    var frInputModel: FRInputModel!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 64
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: FRInputCell.self, for: self, at: index) as! FRInputCell
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        frInputModel = object as? FRInputModel
    }
    
}
