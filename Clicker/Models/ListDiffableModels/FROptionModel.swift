//
//  FROptionModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class FROptionModel: OptionModel {

    var answerId: String
    var numUpvoted: Int
    var didUpvote: Bool
    let identifier = UUID().uuidString
    
    init(option: String, isAnswer: Bool, answerId: String, numUpvoted: Int, didUpvote: Bool) {
        self.answerId = answerId
        self.numUpvoted = numUpvoted
        self.didUpvote = didUpvote
        super.init(option: option, isAnswer: isAnswer)
    }
    
}

extension FROptionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? FROptionModel else { return false }
        return identifier == object.identifier
    }
    
}
