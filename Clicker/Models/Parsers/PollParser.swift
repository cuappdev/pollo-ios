//
//  PollParser.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import SwiftyJSON

class PollParser: Parser {
    
    typealias itemType = Poll
    
    static func parseItem(json: JSON) -> Poll {
        let id = json[ParserKeys.idKey].intValue
        let text = json[ParserKeys.textKey].stringValue
        let results = json[ParserKeys.resultsKey].dictionaryValue
        var options: [String]
        if let optionsArray = json[ParserKeys.optionsKey].array {
            options = optionsArray.map { $0.stringValue }
        } else {
            options = results.keys.sorted()
        }
        let questionType: QuestionType = json[ParserKeys.typeKey].stringValue == Identifiers.multipleChoiceIdentifier
            ? .multipleChoice
            : .freeResponse
        let state: PollState = json[ParserKeys.sharedKey].boolValue ? .shared : .ended
        var answer: String? = nil
        if let unwrappedAnswer = json[ParserKeys.answerKey].string, let answerDict = results[unwrappedAnswer], let answerText = answerDict[ParserKeys.textKey].string {
            answer = answerText
        }
        return Poll(id: id, text: text, questionType: questionType, options: options, results: results, state: state)
    }

    static func parseItem(json: JSON, state: PollState) -> Poll {
        let id = json[ParserKeys.idKey].intValue
        let text = json[ParserKeys.textKey].stringValue
        let results = json[ParserKeys.resultsKey].dictionaryValue
        var options: [String]
        if let optionsArray = json[ParserKeys.optionsKey].array {
            options = optionsArray.map { $0.stringValue }
        } else {
            options = results.keys.sorted()
        }
        let questionType: QuestionType = json[ParserKeys.typeKey].stringValue == Identifiers.multipleChoiceIdentifier
            ? .multipleChoice
            : .freeResponse
        var answer: String?
        if let unwrappedAnswer = json[ParserKeys.answerKey].string, let answerDict = results[unwrappedAnswer], let answerText = answerDict[ParserKeys.textKey].string {
            answer = answerText
        }
        return Poll(id: id, text: text, questionType: questionType, options: options, results: results, state: state)
    }
}
