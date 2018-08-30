//
//  EmptyStateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

protocol PollSectionControllerDelegate {
    var userRole: UserRole { get }
}

class PollSectionController: ListSectionController {
    
    var poll: Poll!
    let widthScaleFactor: CGFloat = 0.9
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width * widthScaleFactor, height: containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: EmptyStateCell.self, for: self, at: index) as! EmptyStateCell
        return cell
    }
    
    override func didUpdate(to object: Any) {
        poll = object as? Poll
    }
    
}
