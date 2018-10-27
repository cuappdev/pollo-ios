//
//  Constants.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

struct Links {
    static let allApps = "https://itunes.apple.com/us/developer/walker-white/id1089672961"
    static let appDevSite = "https://www.cornellappdev.com/"
    static let feedbackForm = "https://goo.gl/forms/9izY3GCRWoA1Fe8e2"
    static let privacyPolicy = "https://www.cornellappdev.com/privacy/policies/pollo/"
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
    static let adminEnded = "admin/poll/ended"
    static let adminStart = "admin/poll/start"
    static let adminUpdateTally = "admin/poll/updateTally"
    static let adminUpdateTallyLive = "admin/poll/updateTally/live"
    static let count = "user/count"
    static let serverEnd = "server/poll/end"
    static let serverShare = "server/poll/results"
    static let serverStart = "server/poll/start"
    static let serverTally = "server/poll/tally"
    static let serverUpvote = "server/poll/upvote"
    static let userStart = "user/poll/start"
    static let userEnd = "user/poll/end"
    static let userResults = "user/poll/results"
    static let userResultsLive = "user/poll/results/live"
}

struct LayoutConstants {
    static let buttonImageInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
    static let buttonSize: CGSize = CGSize(width: 44, height: 44)
    static let frInputCellHeight: CGFloat = 64
    static let frOptionCellHeight: CGFloat = 58
    static let hamburgerCardCellHeight: CGFloat = 25
    static let interItemPadding: CGFloat = 5
    static let mcOptionCellHeight: CGFloat = 50
    static let pollMiscellaneousCellHeight: CGFloat = 30
    static let pollOptionsPadding: CGFloat = 18
    static let cardHorizontalPadding: CGFloat = 18
    static let questionCellHeight: CGFloat = 60
    static let pollBuilderCVHorizontalInset: CGFloat = 18
    static let separatorLineCardCellHeight: CGFloat = 1
    static let separatorLineSettingsCellHeight: CGFloat = 5
    static let noResponsesSpace: CGFloat = 44
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
    static let upvotesKey = "upvotes"
}

struct RequestKeys {
    static let answerIdKey = "answerId"
    static let choiceKey = "choice"
    static let countKey = "count"
    static let googleIdKey = "googleId"
    static let optionsKey = "options"
    static let pollKey = "poll"
    static let sharedKey = "shared"
    static let textKey = "text"
    static let typeKey = "type"
    static let userTypeKey = "userType"
}

struct StringConstants {
    static let freeResponse = "Free Response"
    static let multipleChoice = "Multiple Choice"
    static let dateFormat = "MMM dd yyyy"
}

struct IntegerConstants {
    static let maxQuestionCharacterCount = 58
    static let maxOptionsForAdminMC = 6
    static let maxOptionsForMemberMC = 8
    static let maxOptionsForAdminFR = 5
    static let maxOptionsForMemberFR = 6
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
