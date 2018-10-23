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
        let cellHeight = separatorLineModel.state == .card ? LayoutConstants.separatorLineCardCellHeight : LayoutConstants.separatorLineSettingsCellHeight
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: SeparatorLineCell.self, for: self, at: index) as! SeparatorLineCell
        cell.configure(with: separatorLineModel)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        separatorLineModel = object as? SeparatorLineModel
    }
}
