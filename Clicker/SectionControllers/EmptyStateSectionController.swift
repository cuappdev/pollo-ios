//
//  EmptyStateSectionController.swift
//  Clicker
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
    var shouldDisplayNameView: Bool?
    var nameViewDelegate: NameViewDelegate?

    convenience init(session: Session, shouldDisplayNameView: Bool, nameViewDelegate: NameViewDelegate) {
        self.init()
        self.session = session
        self.shouldDisplayNameView = shouldDisplayNameView
        self.nameViewDelegate = nameViewDelegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.insetContainerSize else {
            return .zero
        }
        return containerSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: EmptyStateCell.self, for: self, at: index) as! EmptyStateCell
        cell.configure(for: emptyStateModel, session: session, shouldDisplayNameView: shouldDisplayNameView, nameViewDelegate: nameViewDelegate)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        emptyStateModel = object as? EmptyStateModel
    }
    
}
