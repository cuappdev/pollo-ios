//
//  MCChoiceModel.swift
//  Pollo
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class MCChoiceModel: OptionModel {
    
    var isSelected: Bool
    let identifier = UUID().uuidString
    
    init(option: String, isSelected: Bool) {
        self.isSelected = isSelected
        super.init(option: option)
    }

}

extension MCChoiceModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? MCChoiceModel else { return false }
        return identifier == object.identifier && option == object.option && isSelected == object.isSelected
    }
    
}
