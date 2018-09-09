//
//  MCChoiceModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class MCChoiceModel {
    
    var option: String
    let identifier = UUID().uuidString
    
    init(option: String) {
        self.option = option
    }
}

extension MCChoiceModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? MCChoiceModel else { return false }
        return identifier == object.identifier
    }
    
}
