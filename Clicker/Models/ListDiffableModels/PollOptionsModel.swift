//
//  PollOptionsModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum PollOptionsModelType {
    case frOption(optionModels: [FROptionModel])
    case mcChoice(choiceModels: [MCChoiceModel])
    case mcResult(resultModels: [MCResultModel])
}

class PollOptionsModel {

    let identifier = UUID().uuidString
    var pollState: PollState
    var type: PollOptionsModelType

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
        if self === object { return true }
        guard let object = object as? PollOptionsModel else { return false }
        return identifier == object.identifier
    }

}
