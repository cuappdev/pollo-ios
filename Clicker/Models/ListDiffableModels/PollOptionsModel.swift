//
//  PollOptionsModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum PollOptionsModelType {
    case mcResult(resultModels: [MCResultModel])
    case mcChoice(choiceModels: [MCChoiceModel])
    case frOption(optionModels: [FROptionModel])
}

class PollOptionsModel {
    
    var type: PollOptionsModelType
    var pollState: PollState
    let identifier = UUID().uuidString
    
    init(type: PollOptionsModelType, pollState: PollState) {
        self.pollState = pollState
        self.type = type
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
