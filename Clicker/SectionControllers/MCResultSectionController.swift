//
//  MCResultSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class MCResultSectionController: ListSectionController {
    
    var resultModel: MCResultModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: LayoutConstants.optionCellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MCResultCell.self, for: self, at: index) as! MCResultCell
        cell.configure(for: resultModel)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        resultModel = object as? MCResultModel
    }
}
