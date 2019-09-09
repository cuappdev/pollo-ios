//
//  HeaderSectionController.swift
//  Pollo
//
//  Created by Mathew Scullin on 3/11/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit

class HeaderSectionController: ListSectionController {
    
    // MARK: - Data Vars
    var headerModel: HeaderModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = headerModel.title.height(withConstrainedWidth: containerSize.width, font: ._18SemiboldFont)
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as! HeaderCell
        cell.configure(for: headerModel)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        headerModel = object as? HeaderModel
    }

}
