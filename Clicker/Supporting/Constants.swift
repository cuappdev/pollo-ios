//
//  Constants.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

enum QuestionType: CustomStringConvertible {
    case multipleChoice
    case freeResponse
    
    var description : String {
        switch self {
        case .multipleChoice: return Identifiers.multipleChoiceIdentifier
        case .freeResponse: return Identifiers.freeResponseIdentifier
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

struct Identifiers {
    static let addMoreOptionCellIdentifier = "addMoreOptionCellId"
    static let adminIdentifier = "admin"
    static let answerIdentifier = "answerCardId"
    static let askedIdentifer = "askedCardId"
    static let createMCOptionCellIdentifier = "createMCOptionCellId"
    static let dateIdentifier = "dateCardId"
    static let draftCellIdentifier = "draftCellId"
    static let freeResponseIdentifier = "FREE_RESPONSE"
    static let multipleChoiceIdentifier = "MULTIPLE_CHOICE"
    static let optionIdentifier = "optionCellId"
    static let pollPreviewIdentifier = "pollPreviewCellId"
    static let questionOptionCellIdentifier = "questionOptionCellId"
    static let resultMCIdentifier = "resultMCCellId"
    static let significantEventsIdentifier = "significantEvents"
}

struct Routes {
    static let serverEnd = "server/poll/end"
    static let serverShare = "server/poll/results"
    static let serverStart = "server/poll/start"
    static let serverTally = "server/poll/tally"
    static let serverUpvote = "server/poll/upvote"
    static let userStart = "user/poll/start"
    static let userEnd = "user/poll/end"
    static let userShare = "user/poll/results"
    static let adminUpdateTally = "admin/poll/updateTally"
    static let adminEnded = "admin/poll/ended"
    static let count = "user/count"
}

struct LayoutConstants {
    static let verticalQuestionCellHeight: CGFloat = 40
    static let verticalMCOptionCellHeight: CGFloat = 44
    static let horizontalMCOptionCellHeight: CGFloat = 50
    static let horizontalFROptionCellHeight: CGFloat = 58
    static let verticalFROptionCellHeight: CGFloat = 52
    static let frInputCellHeight: CGFloat = 64
    static let pollMiscellaneousCellHeight: CGFloat = 30
    static let separatorLineCellHeight: CGFloat = 1
    static let hamburgerCardCellHeight: CGFloat = 25
    static let pollOptionsVerticalPadding: CGFloat = 10
}

struct ParserKeys {
    static let answerKey = "answer"
    static let answersKey = "answers"
    static let countKey = "count"
    static let idKey = "id"
    static let optionsKey = "options"
    static let pollKey = "poll"
    static let resultsKey = "results"
    static let sharedKey = "shared"
    static let textKey = "text"
    static let typeKey = "type"
}

struct RequestKeys {
    static let googleIdKey = "googleId"
    static let optionsKey = "options"
    static let pollKey = "poll"
    static let choiceKey = "choice"
    static let countKey = "count"
    static let textKey = "text"
    static let typeKey = "type"
    static let sharedKey = "shared"
    static let userTypeKey = "userType"
}

enum Keys: String {
    case apiURL = "api-url"
    case apiDevURL = "api-dev-url"
    case fabricAPIKey = "fabric-api-key"
    
    var value: String {
        return Keys.keyDict[rawValue] as! String
    }
    
    static var hostURL: Keys {
        #if DEV_SERVER
        return Keys.apiDevURL
        #else
        return Keys.apiURL
        #endif
    }
    
    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}

struct Device {
    static let id: String = {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            return deviceId
        } else {
            return UUID().uuidString
        }
    }()
    
    private init() {}
}

struct Google {
    static let googleClientID = "43978214891-pk0scb60nvn2ofa5acccd58k79n4llkg.apps.googleusercontent.com"
    
    private init() {}
}
