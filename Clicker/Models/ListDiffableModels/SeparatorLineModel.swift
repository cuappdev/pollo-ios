//
//  SeparatorLineModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class SeparatorLineModel: ListDiffable  {
    
    let identifier = UUID().uuidString
 
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? SeparatorLineModel else { return false }
        return identifier == object.identifier
    }
    
}
