//
//  EmptyStateModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

class EmptyStateModel: ListDiffable {
    
    var userRole: UserRole
    let identifier = UUID().uuidString
    
    init(userRole: UserRole) {
        self.userRole = userRole
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? EmptyStateModel else { return false }
        return identifier == object.identifier
    }
}
