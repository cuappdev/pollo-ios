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

class PollResult: Codable, Equatable {

    static func == (lhs: PollResult, rhs: PollResult) -> Bool {
        return lhs.letter == rhs.letter && lhs.text == rhs.text && lhs.count == rhs.count
    }

    var count: Int?
    var letter: Int
    var text: String
    
    init(letter: Int, text: String, count: Int?) {
        self.letter = letter
        self.text = text
        self.count = count
    }

}

struct PollFilter: Codable {
    var success: Bool
    var text: String? // passed in when success = false
    var filter: [String]? // passed in when success = false
}

class Poll: Codable {

    var answerChoices: [PollResult]
    var correctAnswer: Int
    var createdAt: String? // string of seconds since 1970
    var id: String?
    var pollFilter: PollFilter? // used for filtering user profanity
    var state: PollState
    var text: String
    var updatedAt: String?
    var userAnswers: [String: [Int]] // googleID to index of choice
    // results format:
    // {'User1': {3, 0, 1}, ...}

    // MARK: - Constants
    let identifier = UUID().uuidString
    
    init(createdAt: String? = nil, updatedAt: String? = nil, id: String = "", text: String, answerChoices: [PollResult], correctAnswer: Int? = nil, userAnswers: [String: [Int]], state: PollState) {
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.text = text
        self.answerChoices = answerChoices
        self.correctAnswer = correctAnswer ?? -1
        self.userAnswers = userAnswers
        self.state = state
    }

    init(poll: Poll, state: PollState) {
        self.id = poll.id
        self.text = poll.text
        self.answerChoices = poll.answerChoices
        self.correctAnswer = poll.correctAnswer
        self.userAnswers = poll.userAnswers
        self.state = state
    }

    func getSelected() -> Int? {
        if userAnswers.isEmpty { return nil }
        guard let googleID = User.currentUser?.id, let answers = userAnswers[googleID], let answer = answers.first else { return nil }
        return answer
    }

    // MARK: - Public
    func update(with poll: Poll) {
        self.id = poll.id
        self.text = poll.text
        self.answerChoices = poll.answerChoices
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

    // Returns whether user selected this multiple choice (0, 1, 2, ...)
    func userDidSelect(mcChoice: Int) -> Bool {
        guard let googleID = User.currentUser?.id, let userSelectedAnswers = userAnswers[googleID], let letter = userSelectedAnswers.first else { return false }
        return letter == mcChoice
    }

    func updateSelected(mcChoice: Int) {
        guard let googleID = User.currentUser?.id else { return }
        userAnswers[googleID] = [mcChoice]
    }

}

extension Poll: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Poll else { return false }
        return id == object.id && text == object.text && answerChoices == object.answerChoices
    }
    
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
