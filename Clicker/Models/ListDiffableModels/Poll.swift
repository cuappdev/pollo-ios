//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SwiftyJSON

protocol PollTimeKeeper {
    func startTimerWith(target aTarget: Any, selector aSelector: Selector)
}

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
    
    /// `timeLive` is how long a poll has been live for, so we can make the timer for each poll start correctly if a poll is already live when its cell is configured.
    var timeLive: Int?
    var timer: Timer?
    
    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(id: Int = -1, text: String, questionType: QuestionType, options: [String], results: [String:JSON], state: PollState, answer: String?, timeLive: Int? = nil) {
        self.id = id
        self.text = text
        self.questionType = questionType
        self.options = options
        self.results = results
        self.state = state
        self.answer = answer
        
        if state == .live {
            self.timeLive = timeLive ?? 0
        } else {
            self.timeLive = nil
        }
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
        return id == object.id && text == object.text && questionType == object.questionType
    }
    
}

extension Poll: PollTimeKeeper {
    
    func startTimerWith(target aTarget: Any, selector aSelector: Selector) {
        if let t = timer {
            t.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: aTarget, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    
}
