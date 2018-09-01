//
//  HamburgerCardSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class HamburgerCardSectionController: ListSectionController {
    
    var hamburgerCardModel: HamburgerCardModel!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 25
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: HamburgerCardCell.self, for: self, at: index) as! HamburgerCardCell
        cell.configure(for: hamburgerCardModel)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        hamburgerCardModel = object as? HamburgerCardModel
    }
    
}
