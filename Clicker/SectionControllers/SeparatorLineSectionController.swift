//
//  SeparatorLineSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class SeparatorLineSectionController: ListSectionController {
    
    var separatorLineModel: SeparatorLineModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: LayoutConstants.separatorLineCellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: SeparatorLineCell.self, for: self, at: index) as! SeparatorLineCell
        return cell
    }
    
    override func didUpdate(to object: Any) {
        separatorLineModel = object as? SeparatorLineModel
    }
}
