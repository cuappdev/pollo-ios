//
//  PollButtonModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class PollButtonModel {
    
    var state: PollState
    let identifier = UUID().uuidString
    
    init(state: PollState) {
        self.state = state
    }
    
}

extension PollButtonModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? PollButtonModel else { return false }
        return identifier == object.identifier
    }
    
}
