//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SwiftyJSON

enum PollState {
    case live
    case ended
    case shared
}

class Poll {
    
    var id: Int
    var text: String
    var questionType: QuestionType
    var options: [String]
    var results: [String:JSON]
    var state: PollState
    var answer: String?
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}
    // FREE_RESPONSE: {'Blue': {'text': 'Blue', 'count': 3}, ...}
    
    /// `startTime` is the time (in seconds since 1970) that the poll was started.
    var startTime: Double?
    
    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(id: Int = -1, text: String, questionType: QuestionType, options: [String], results: [String:JSON], state: PollState, answer: String?) {
        self.id = id
        self.text = text
        self.questionType = questionType
        self.options = options
        self.results = results
        self.state = state
        self.answer = answer
        
        self.startTime = state == .live ? NSDate().timeIntervalSince1970 : nil
     
    }
    
    init(poll: Poll, currentState: CurrentState, updatedPollState: PollState?) {
        self.id = poll.id
        self.text = poll.text
        self.questionType = poll.questionType
        self.options = poll.options
        self.results = currentState.results
        self.state = updatedPollState ?? poll.state
        self.answer = poll.answer
        self.startTime = poll.startTime
    }

    
    // Returns array representation of results
    // Ex) [('Blah', 3), ('Jupiter', 2)...]
    func getFRResultsArray() -> [(String, Int)] {
        return options.map { (option) -> (String, Int) in
            if let choiceJSON = results[option], let numSelected = choiceJSON[ParserKeys.countKey].int {
                return (option, numSelected)
            }
            return (option, 0)
        }
    }
    
    func getTotalResults() -> Int {
        return results.values.reduce(0) { (currentTotalResults, json) -> Int in
            return currentTotalResults + json[ParserKeys.countKey].intValue
        }
    }

}

extension Poll: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? Poll else { return false }
        return id == object.id && text == object.text && questionType == object.questionType && results == object.results
    }
    
}
