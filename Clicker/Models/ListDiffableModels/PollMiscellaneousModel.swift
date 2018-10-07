//
//  PollMiscellaneousModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class PollMiscellaneousModel {
    
    var questionType: QuestionType!
    var pollState: PollState
    var totalVotes: Int
    let identifier = UUID().uuidString
    
    init(questionType: QuestionType, pollState: PollState, totalVotes: Int) {
        self.questionType = questionType
        self.pollState = pollState
        self.totalVotes = totalVotes
    }
    
}

extension PollMiscellaneousModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? PollMiscellaneousModel else { return false }
        return identifier == object.identifier
    }
    
}
