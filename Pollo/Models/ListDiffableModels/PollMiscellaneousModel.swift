//
//  PollMiscellaneousModel.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class PollMiscellaneousModel {

    let identifier = UUID().uuidString
    var didSubmitChoice: Bool
    var pollState: PollState
    var questionType: QuestionType!
    var totalResponses: Int
    var userRole: UserRole

    init(questionType: QuestionType, pollState: PollState, totalResponses: Int, userRole: UserRole, didSubmitChoice: Bool) {
        self.questionType = questionType
        self.pollState = pollState
        self.totalResponses = totalResponses
        self.userRole = userRole
        self.didSubmitChoice = didSubmitChoice
    }

}

extension PollMiscellaneousModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? PollMiscellaneousModel else { return false }
        return identifier == object.identifier
    }

}
