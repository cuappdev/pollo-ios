//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SwiftyJSON

enum PollState: String, Codable {
    case live, ended, shared
}

enum QuestionType: String, CustomStringConvertible, Codable {
    case multipleChoice = "Multiple Choice"
    case freeResponse = "Free Response"
    
    var description: String {
        switch self {
        case .multipleChoice: return StringConstants.multipleChoice
        case .freeResponse: return StringConstants.freeResponse
        }
    }
    
    var descriptionForServer: String {
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

class PollResult: Codable, Equatable {
    
    static func == (lhs: PollResult, rhs: PollResult) -> Bool {
        return lhs.text == rhs.text && lhs.count == rhs.count
    }
    
    var text: String
    var count: Int
    
    init(text: String, count: Int) {
        self.text = text
        self.count = count
    }
    
}

class PollAnswer: Codable {
    
    var answer: String?
    var answerIds: [Int]?
    
    init(answer: String?, answerIds: [Int]?) {
        self.answer = answer
        self.answerIds = answerIds
    }
    
}

class Poll: Codable {
    
    var id: Int
    var text: String
    var questionType: QuestionType
    var options: [String]
    var results: [String: PollResult]
    var answers: [String: PollAnswer]
    var upvotes: [String: [String]]
    var state: PollState
    var correctAnswer: String?  // only exists for multiple choice (format: 'A', 'B', ...)
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}
    // FREE_RESPONSE: {1: {'text': 'Blue', 'count': 3}, ...}
    
    /// `startTime` is the time (in seconds since 1970) that the poll was started.
    var startTime: Double?
    
    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(id: Int = -1, text: String, questionType: QuestionType, options: [String], results: [String: PollResult], state: PollState, correctAnswer: String?) {
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
        guard let selected = answers[userId] else { return nil }
        switch questionType {
        case .multipleChoice:
            guard let answer = selected.answer else { return nil }
            return answer
        case .freeResponse:
            guard let answerIds = selected.answerIds else { return nil }
            return answerIds
        }
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
        return options.compactMap { answerId -> (String, String, Int)? in
            guard let choice = results[answerId] else { return nil }
            return (answerId, choice.text, choice.count)
        }
    }
    
    func getTotalResults() -> Int {
        return results.values.reduce(0) { (currentTotalResults, result) -> Int in
            return currentTotalResults + result.count
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
        guard let userSelectedAnswer = answers[userId] else { return false }
        guard let userSelectedChoice = userSelectedAnswer.answer else { return false }
        return userSelectedChoice == mcChoice
    }

    func updateSelected(mcChoice: String) {
        if let userId = User.currentUser?.id {
            answers[userId] = PollAnswer(answer: mcChoice, answerIds: nil)
        }
    }

}

extension Poll: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Poll else { return false }
        return id == object.id && text == object.text && questionType == object.questionType && results == object.results
    }
    
}
