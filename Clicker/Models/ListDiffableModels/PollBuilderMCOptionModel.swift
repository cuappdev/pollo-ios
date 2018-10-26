//
//  PollBuilderMCOptionModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum PollBuilderMCOptionModelType {
    case newOption(option: String, index: Int, isCorrect: Bool)
    case addOption
}

class PollBuilderMCOptionModel {
    
    var type: PollBuilderMCOptionModelType
    var totalOptions: Int
    let identifier = UUID().uuidString
    
    init(type: PollBuilderMCOptionModelType) {
        self.type = type
        self.totalOptions = -1
    }
    
}

extension PollBuilderMCOptionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? PollBuilderMCOptionModel else { return false }
        return identifier == object.identifier && totalOptions == object.totalOptions
    }
    
}
