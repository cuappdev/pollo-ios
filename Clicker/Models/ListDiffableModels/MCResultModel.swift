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
    var isSelected: Bool
    var choiceIndex: Int
    let identifier = UUID().uuidString
    
    init(option: String, numSelected: Int, percentSelected: Float, isSelected: Bool, choiceIndex: Int) {
        self.numSelected = numSelected
        self.percentSelected = percentSelected
        self.isSelected = isSelected
        self.choiceIndex = choiceIndex
        super.init(option: option)
    }

    // MARK: - Custom isEqual method to use when comparing an updated MCResultModel
    func isEqual(toUpdatedModel mcResultModel: MCResultModel) -> Bool {
        return option == mcResultModel.option && numSelected == mcResultModel.numSelected && percentSelected == mcResultModel.percentSelected
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
