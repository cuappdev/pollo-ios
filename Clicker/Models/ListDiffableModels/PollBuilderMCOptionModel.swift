//
//  PollBuilderMCOptionModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum PollBuilderMCOptionModelType {
    case addOption
    case newOption(option: String, index: Int, isCorrect: Bool)
}

class PollBuilderMCOptionModel {

    let identifier = UUID().uuidString
    var totalOptions: Int
    var type: PollBuilderMCOptionModelType

    init(type: PollBuilderMCOptionModelType) {
        self.totalOptions = -1
        self.type = type
    }

}

extension PollBuilderMCOptionModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? PollBuilderMCOptionModel else { return false }
        return identifier == object.identifier && totalOptions == object.totalOptions
    }

}
