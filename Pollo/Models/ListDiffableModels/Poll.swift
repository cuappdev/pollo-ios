//
//  Poll.swift
//  Pollo
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

    var description: String {
        switch self {
        case .multipleChoice: return StringConstants.multipleChoice
        }
    }

    var descriptionForServer: String {
        switch self {
        case .multipleChoice: return Identifiers.multipleChoiceIdentifier
        }
    }
}

class PollResult: Codable, Equatable {

    static func == (lhs: PollResult, rhs: PollResult) -> Bool {
        return lhs.letter == rhs.letter && lhs.text == rhs.text && lhs.count == rhs.count
    }

    var count: Int?
    var letter: String?
    var text: String
    
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

    var answerChoices: [PollResult]
    var correctAnswer: String?  // only exists for multiple choice (format: 'A', 'B', ...)
    var createdAt: String? // string of seconds since 1970
    var id: String?
    var state: PollState
    var text: String
    var type: QuestionType
    var updatedAt: String?
    var userAnswers: [String: [PollChoice]] // googleID to poll choice
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}

    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(createdAt: String? = nil, updatedAt: String? = nil, id: String? = nil, text: String, answerChoices: [PollResult], type: QuestionType, correctAnswer: String? = nil, userAnswers: [String: [PollChoice]], state: PollState) {
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
        if userAnswers.isEmpty { return nil }
        guard let googleID = User.currentUser?.id, let answers = userAnswers[googleID], !answers.isEmpty else { return nil }
        switch type {
        case .multipleChoice:
            guard let answer = answers[0].letter else { return nil }
            return answer
        }
    }

    // MARK: - Public
    func update(with poll: Poll) {
        self.id = poll.id
        self.text = poll.text
        self.answerChoices = poll.answerChoices
        self.type = poll.type
        self.correctAnswer = poll.correctAnswer
        self.userAnswers = poll.userAnswers
        self.state = poll.state
    }
    
    func totalResults(from choices: [PollResult]) -> Int {
        return choices.reduce(0) { (total, choice) -> Int in
            return total + (choice.count ?? 0)
        }
    }
    
    func getTotalResults(for userRole: UserRole) -> Int {
        switch userRole {
        case .member:
            return state == .shared ? totalResults(from: answerChoices) : 0
        case .admin:
            return totalResults(from: answerChoices)
        }
    }

    // Returns whether user selected this multiple choice (A, B, C, ...)
    func userDidSelect(mcChoice: String) -> Bool {
        guard let googleID = User.currentUser?.id, let userSelectedAnswers = userAnswers[googleID], let letter = userSelectedAnswers.first?.letter else { return false }
        return letter == mcChoice
    }

    func updateSelected(mcChoice: String, choice: String) {
        guard let googleID = User.currentUser?.id else { return }
        userAnswers[googleID] = [PollChoice(letter: mcChoice, text: choice)]
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
