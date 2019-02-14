//
//  PollsDateModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

struct PollsResponse: Codable {
    
    var id: Int
    var text: String
    var results: [String : PollResult]
    var shared: Bool
    var type: String
    var correctAnswer: String?
    
}

struct GetSortedPollsResponse: Codable {
    
    var date: String
    var polls: [PollsResponse]
    
}

class PollsDateModel: Codable {
    
    var date: String
    var polls: [Poll]
    let identifier = UUID().uuidString
    
    init(date: String, polls: [Poll]) {
        self.date = date
        self.polls = polls
    }
    
}

extension PollsDateModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? PollsDateModel else { return false }
        return identifier == object.identifier
    }
}
