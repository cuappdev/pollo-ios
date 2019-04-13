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
    case multipleChoice
    case freeResponse
    
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
        return lhs.letter == rhs.letter && lhs.text == rhs.text && lhs.count == rhs.count
    }

    var letter: String?
    var text: String
    var count: Int?
    
    init(letter: String? = nil, text: String, count: Int?) {
        self.letter = letter
        self.text = text
        self.count = count
    }
    
}

class PollChoice: Codable {
    var letter: String?
    var text: String

    init(letter: String? = nil, text: String) {
        self.letter = letter
        self.text = text
    }
}

class Poll: Codable {
    var createdAt: Date? // string of seconds since 1970
    var updatedAt: Date?
    var id: Int?
    var text: String
    var answerChoices: [PollResult]
    var type: QuestionType
    var correctAnswer: String?  // only exists for multiple choice (format: 'A', 'B', ...)
    var userAnswers: [String: [PollChoice]] // googleID to poll choice
    var state: PollState
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}
    // FREE_RESPONSE: {1: {'text': 'Blue', 'count': 3}, ...}

    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(createdAt: Date? = nil, updatedAt: Date? = nil, id: Int = -1, text: String, answerChoices: [PollResult], type: QuestionType, correctAnswer: String? = nil, userAnswers: [String: [PollChoice]], state: PollState) {
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.text = text
        self.answerChoices = answerChoices
        self.type = type
        self.correctAnswer = correctAnswer
        self.userAnswers = userAnswers
        self.state = state
    }

    init(poll: Poll, state: PollState) {
        self.id = poll.id
        self.text = poll.text
        self.answerChoices = poll.answerChoices
        self.type = poll.type
        self.correctAnswer = poll.correctAnswer
        self.userAnswers = poll.userAnswers
        self.state = state
    }

    func getSelected() -> Any? {
        guard let userId = User.currentUser?.id else { return nil }
        guard let selected = userAnswers[userId] else { return nil }
        switch type {
        case .multipleChoice:
            guard let answer = selected[0].letter else { return nil }
            return answer
        case .freeResponse:
            return selected[0].text
        }
    }

    // MARK: - Public
    func update(with poll: Poll) {
        // TODO: determine if this function is necessary
        self.id = poll.id
        self.text = poll.text
        self.answerChoices = poll.answerChoices
        self.type = poll.type
        self.correctAnswer = poll.correctAnswer
        self.userAnswers = poll.userAnswers
        self.state = poll.state
    }
    
    // Returns array representation of results where each element is (text, count)
    // Ex) [('Blah', 3), ('Jupiter', 6)...]
    func getFRResultsArray() -> [(String, Int)] {
        return answerChoices.compactMap { pollResult -> (String, Int)? in
            guard let count = pollResult.count else { return nil }
            return (pollResult.text, count)
        }
    }
    
    func getTotalResults() -> Int {
        return userAnswers.values.reduce(0) { (currentTotalResults, result) -> Int in
            return currentTotalResults + (result.count)
        }
    }

    // Returns whether user upvoted answerId
    func userDidUpvote(answerText: String) -> Bool {
        if let userId = User.currentUser?.id, let userUpvotedAnswer = userAnswers[userId] {
            return userUpvotedAnswer.contains { $0.text == answerText }
        }
        return false
    }

    // Returns whether user selected this multiple choice (A, B, C, ...)
    func userDidSelect(mcChoice: String) -> Bool {
        guard let userId = User.currentUser?.id else { return false }
        guard let userSelectedLetterAnswer = userAnswers[userId]?[0].letter else { return false }
        return userSelectedLetterAnswer == mcChoice
    }

    func updateSelected(mcChoice: String) {
        if let userId = User.currentUser?.id {
            // This should never be nil
            userAnswers[userId]?[0] = PollChoice(text: mcChoice)
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
        return id == object.id && text == object.text && type == object.type && answerChoices == object.answerChoices
    }
    
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

