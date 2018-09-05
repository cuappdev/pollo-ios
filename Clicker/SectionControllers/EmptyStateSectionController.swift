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
    
    var emptyStateModel: EmptyStateModel!
    
    // MARK: Must pass these to the EmptyStateCell
    var session: Session!
    var userRole: UserRole!
    var nameViewDelegate: NameViewDelegate!
    
    init(session: Session, userRole: UserRole, nameViewDelegate: NameViewDelegate) {
        super.init()
        self.session = session
        self.userRole = userRole
        self.nameViewDelegate = nameViewDelegate
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
        cell.session = session
        cell.userRole = userRole
        cell.nameViewDelegate = nameViewDelegate
        cell.setup()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        emptyStateModel = object as? EmptyStateModel
    }
    
}
