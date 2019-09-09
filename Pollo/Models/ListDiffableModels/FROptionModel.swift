//
//  FROptionModel.swift
//  Pollo
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class FROptionModel: OptionModel {

    var didUpvote: Bool
    let identifier = UUID().uuidString
    var numUpvoted: Int
    
    init(option: String, numUpvoted: Int, didUpvote: Bool) {
        self.didUpvote = didUpvote
        self.numUpvoted = numUpvoted
        super.init(option: option)
    }

}

extension FROptionModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString 
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? FROptionModel else { return false }
        return identifier == object.identifier
    }

}
