//
//  SpaceSectionController.swift
//  Clicker
//
//  Created by Matthew Coufal on 10/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class SpaceSectionController: ListSectionController {
    
    var spaceModel: SpaceModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: spaceModel.space)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: SpaceCell.self, for: self, at: index) as! SpaceCell
        cell.configure(with: spaceModel.space)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        spaceModel = object as? SpaceModel
    }

}
