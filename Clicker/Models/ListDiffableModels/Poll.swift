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

enum QuestionType: CustomStringConvertible {
    case multipleChoice
    case freeResponse
    
    var description : String {
        switch self {
        case .multipleChoice: return StringConstants.multipleChoice
        case .freeResponse: return StringConstants.freeResponse
        }
    }
    
    var descriptionForServer : String {
        switch self {
        case .multipleChoice: return Identifiers.multipleChoiceIdentifier
        case .freeResponse: return Identifiers.freeResponseIdentifier
        }
    }
    
    var other: QuestionType {
        switch self {
        case .multipleChoice: return .freeResponse
        case .freeResponse: return .multipleChoice
        }
    }
}

class Poll {
    
    var id: Int
    var text: String
    var questionType: QuestionType
    var options: [String]
    var results: [String:JSON]
    var answers: [String:Any]
    var upvotes: [String:[String]]
    var state: PollState
    var correctAnswer: String?  // only exists for multiple choice (format: 'A', 'B', ...)
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}
    // FREE_RESPONSE: {1: {'text': 'Blue', 'count': 3}, ...}
    
    /// `startTime` is the time (in seconds since 1970) that the poll was started.
    var startTime: Double?
    
    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(id: Int = -1, text: String, questionType: QuestionType, options: [String], results: [String:JSON], state: PollState, correctAnswer: String?) {
        self.id = id
        self.text = text
        self.questionType = questionType
        self.options = options
        self.results = results
        self.answers = [:]
        self.upvotes = [:]
        self.state = state
        self.correctAnswer = correctAnswer
        self.startTime = state == .live ? NSDate().timeIntervalSince1970 : nil

    }
    
    init(poll: Poll, currentState: CurrentState, updatedPollState: PollState?) {
        self.id = poll.id
        self.text = poll.text
        self.questionType = poll.questionType
        self.options = poll.options
        self.results = currentState.results
        self.answers = currentState.answers
        self.upvotes = currentState.upvotes
        self.state = updatedPollState ?? poll.state
        self.startTime = poll.startTime
        self.correctAnswer = poll.correctAnswer
    }
    
    func getSelected() -> Any? {
        guard let userId = User.currentUser?.id else { return nil }
        if let selected = answers[userId] as? JSON {
            switch questionType {
            case .multipleChoice:
                return selected.stringValue
            case .freeResponse:
                return selected.arrayValue.map { (json) -> Int in
                    return json.intValue
                }
            }
        } else if let selected = answers[userId] as? String {
            return selected
        }
        return nil
    }

    init(poll: Poll, state: PollState) {
        self.id = poll.id
        self.text = poll.text
        self.questionType = poll.questionType
        self.options = poll.options
        self.results = poll.results
        self.answers = poll.answers
        self.upvotes = poll.upvotes
        self.state = state
        self.startTime = poll.startTime
        self.correctAnswer = poll.correctAnswer
    }

    // MARK: - Public
    func update(with currentState: CurrentState) {
        self.results = currentState.results
        self.answers = currentState.answers
        self.upvotes = currentState.upvotes
    }
    
    // Returns array representation of results where each element is (answerId, text, count)
    // Ex) [(1, 'Blah', 3), (2, 'Jupiter', 6)...]
    func getFRResultsArray() -> [(String, String, Int)] {
        return options.compactMap { (answerId) -> (String, String, Int)? in
            if let choiceJSON = results[answerId], let option = choiceJSON[ParserKeys.textKey].string, let numSelected = choiceJSON[ParserKeys.countKey].int {
                return (answerId, option, numSelected)
            }
            return nil
        }
    }
    
    func getTotalResults() -> Int {
        return results.values.reduce(0) { (currentTotalResults, json) -> Int in
            return currentTotalResults + json[ParserKeys.countKey].intValue
        }
    }

    // Returns whether user upvoted answerId
    func userDidUpvote(answerId: String) -> Bool {
        if let userId = User.currentUser?.id, let userUpvotedAnswerIds = upvotes[userId] {
            return userUpvotedAnswerIds.contains(answerId)
        }
        return false
    }

    // Returns whether user selected this multiple choice (A, B, C, ...)
    func userDidSelect(mcChoice: String) -> Bool {
        guard let userId = User.currentUser?.id else { return false }
        if let userSelectedChoice = answers[userId] as? JSON {
            return userSelectedChoice.stringValue == mcChoice
        } else if let userSelectedChoice = answers[userId] as? String {
            return userSelectedChoice == mcChoice
        }
        return false
    }

    func updateSelected(mcChoice: String) {
        if let userId = User.currentUser?.id {
            answers[userId] = mcChoice
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
