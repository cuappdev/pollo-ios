//
//  PollParser.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

//import Foundation
//import SwiftyJSON
//
//class PollParser: Parser {
//
//    typealias ItemType = Poll
//
////    static func parseItem(json: JSON) -> Poll {
////        let createdAt = json[ParserKeys.createdAtKey].stringValue
////        let updatedAt = json[ParserKeys.updatedAtKey].stringValue
////        let id = json[ParserKeys.idKey].intValue
////        let text = json[ParserKeys.textKey].stringValue
////        let results = json[ParserKeys.resultsKey].dictionaryValue
////        let pollResults = formatResults(results: results)
////        let correctAnswer = json[ParserKeys.correctAnswerKey].string
////        let state = json[ParserKeys.stateKey]
////        var options: [String]
////        if let optionsArray = json[ParserKeys.optionsKey].array {
////            options = optionsArray.map { $0.stringValue }
////        } else {
////            options = results.keys.sorted()
////        }
////        let questionType: QuestionType = json[ParserKeys.typeKey].stringValue == Identifiers.multipleChoiceIdentifier
////            ? .multipleChoice
////            : .freeResponse
////        let state: PollState = json[ParserKeys.sharedKey].boolValue ? .shared : .ended
////        let poll = Poll(id: id, text: text, questionType: questionType, options: options, results: pollResults, state: state, correctAnswer: correctAnswer)
////        let poll2 = Poll(createdAt: createdAt, updatedAt: updatedAt, id: id, text: text, answerChoices: , type: , correctAnswer: correctAnswer, userAnswers: , results: , state: )
////        if let unwrappedAnswer = json[ParserKeys.answerKey].string, let answerDict = results[unwrappedAnswer], let answerText = answerDict[ParserKeys.textKey].string {
////            poll.updateSelected(mcChoice: answerText)
////        }
////        return poll
////    }
//}
