//
//  MCResultModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class MCResultModel {
    
    var option: String
    var numSelected: Int
    var percentSelected: Float
    var isAnswer: Bool
    let identifier = UUID().uuidString
    
    init(option: String, numSelected: Int, percentSelected: Float, isAnswer: Bool) {
        self.option = option
        self.numSelected = numSelected
        self.percentSelected = percentSelected
        self.isAnswer = isAnswer
    }
}

extension MCResultModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? MCResultModel else { return false }
        return identifier == object.identifier
    }
    
}
