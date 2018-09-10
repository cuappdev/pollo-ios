//
//  MCResultModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class MCResultModel: OptionModel {
    
    var numSelected: Int
    var percentSelected: Float
    let identifier = UUID().uuidString
    
    init(option: String, numSelected: Int, percentSelected: Float, isAnswer: Bool) {
        self.numSelected = numSelected
        self.percentSelected = percentSelected
        super.init(option: option, isAnswer: false)
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
