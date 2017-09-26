//
//  Session.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

enum QuestionType: String {
    case multipleChoice, freeResponse
}


class Session: NSObject {
    
    var question: String
    var questionType: QuestionType
    var timeLimit: Int
    var numResponses: Int
    var answers: [User : String] = [User : String]()
    
    // NOTE: Only a session whose questionType is multipleChoice should
    // have non-nil values for choices and correctAnswer
    var choices: [String]?
    var correctAnswer: Int?
    
    
    // init for a freeResponse question
    init(question: String, timeLimit: Int) {
        self.question = question
        self.questionType = .freeResponse
        self.timeLimit = timeLimit
        self.numResponses = 0
    }
    
    
    // init for a multipleChoice question
    convenience init(question: String, choices: [String], correctAnswer: Int, timeLimit: Int) {
        self.init(question: question, timeLimit: timeLimit)
        self.questionType = .multipleChoice
        self.choices = choices
        self.correctAnswer = correctAnswer
    }
    
    
    func newFRQuestion(question: String, timeLimit: Int) {
        self.question = question
        self.questionType = .freeResponse
        self.timeLimit = timeLimit
        answers.removeAll()
        self.choices = nil
        self.correctAnswer = nil
        self.numResponses = 0
    }
    
    
    func newMCQuestion(question: String, timeLimit: Int, choices: [String], correctAnswer: Int) {
        self.question = question
        self.questionType = .multipleChoice
        self.timeLimit = timeLimit
        answers.removeAll()
        self.choices = choices
        self.correctAnswer = correctAnswer
        self.numResponses = 0
    }
    
    func insertNewAnswer(_ user: User, _ ans: String) {
        answers[user] = ans
    }
    
    
    
}
