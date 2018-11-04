//
//  PollMiscellaneousSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class PollMiscellaneousSectionController: ListSectionController {
    
    var miscellaneousModel: PollMiscellaneousModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: LayoutConstants.pollMiscellaneousCellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollMiscellaneousCell.self, for: self, at: index) as! PollMiscellaneousCell
        print("configure")
        cell.configure(for: miscellaneousModel)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        print("did update")
        miscellaneousModel = object as? PollMiscellaneousModel
    }
}
