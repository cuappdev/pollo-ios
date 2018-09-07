//
//  PollOptionsModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class PollOptionsModel {
    
    var mcResultModels: [MCResultModel]?
    let identifier = UUID().uuidString
    
    init(multipleChoiceResultModels: [MCResultModel]) {
        self.mcResultModels = multipleChoiceResultModels
    }
    
}

extension PollOptionsModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? PollOptionsModel else { return false }
        return identifier == object.identifier
    }
    
}
