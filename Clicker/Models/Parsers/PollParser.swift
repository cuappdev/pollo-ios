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
        let options = json[ParserKeys.optionsKey].arrayValue.map { $0.stringValue }
        let results = json[ParserKeys.resultsKey].dictionaryValue
        let questionType: QuestionType = json[ParserKeys.typeKey].stringValue == Identifiers.multipleChoiceIdentifier
            ? .multipleChoice
            : .freeResponse
        let state: PollState = json[ParserKeys.sharedKey].boolValue ? .shared : .ended
        var answer: String? = nil
        if let unwrappedAnswer = json[ParserKeys.answerKey].string, let answerDict = results[unwrappedAnswer], let answerText = answerDict[ParserKeys.textKey].string {
            answer = answerText
        }
        return Poll(id: id, text: text, questionType: questionType, options: options, results: results, state: state, answer: answer)
    }

}
