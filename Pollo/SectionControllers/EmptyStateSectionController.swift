//
//  EmptyStateSectionController.swift
//  Pollo
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

class EmptyStateSectionController: ListSectionController {
    
    // MARK: - Data vars
    var emptyStateModel: EmptyStateModel!
    var session: Session?

    convenience init(session: Session?) {
        self.init()
        self.session = session
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return containerSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: EmptyStateCell.self, for: self, at: index) as! EmptyStateCell
        cell.configure(for: emptyStateModel, session: session)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        emptyStateModel = object as? EmptyStateModel
    }
    
}
