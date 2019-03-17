//
//  GroupControlsInfoSectionController.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/11/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit

class GroupControlsInfoSectionController: ListSectionController {
    
    // MARK: - Data Vars
    var infoModel: GroupControlsInfoModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = infoModel.code.height(withConstrainedWidth: containerSize.width, font: ._16MediumFont)
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GroupControlsInfoCell.self, for: self, at: index) as! GroupControlsInfoCell
        cell.configure(for: infoModel)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        infoModel = object as? GroupControlsInfoModel
    }
    
}
