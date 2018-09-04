//
//  QuestionModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class QuestionModel {
    
    var question: String
    let identifier = UUID().uuidString
    
    init(question: String) {
        self.question = question
    }
    
}

extension QuestionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? QuestionModel else { return false }
        return identifier == object.identifier
    }
    
}


