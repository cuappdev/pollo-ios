//
//  Constants.swift
//  Pollo
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
    static let adminUpdates = "admin/poll/updates"
    static let adminUpdateTally = "admin/poll/updateTally"
    static let adminUpdateTallyLive = "admin/poll/updateTally/live"
    static let count = "user/count"
    static let serverAnswer = "server/poll/answer"
    static let serverDelete = "server/poll/delete"
    static let serverDeleteLive = "server/poll/delete/live"
    static let serverEnd = "server/poll/end"
    static let serverShare = "server/poll/results"
    static let serverStart = "server/poll/start"
    static let serverTally = "server/poll/tally"
    static let userDelete = "user/poll/delete"
    static let userDeleteLive = "user/poll/delete/live"
    static let userEnd = "user/poll/end"
    static let userResults = "user/poll/results"
    static let userStart = "user/poll/start"
}

struct LayoutConstants {
    static let buttonImageInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
    static let buttonSize: CGSize = CGSize(width: 44, height: 44)
    static let cardHorizontalPadding: CGFloat = 18
    static let frInputCellHeight: CGFloat = 64
    static let frOptionCellHeight: CGFloat = 58
    static let hamburgerCardCellHeight: CGFloat = 25
    static let interItemPadding: CGFloat = 5
    static let mcOptionCellHeight: CGFloat = 58
    static let moreButtonWidth: CGFloat = 25
    static let noResponsesSpace: CGFloat = 44
    static let pollBuilderCVHorizontalInset: CGFloat = 18
    static let pollMiscellaneousCellHeight: CGFloat = 30
    static let pollOptionsBottomPadding: CGFloat = 16
    static let pollOptionsPadding: CGFloat = 18
    static let questionCellHeight: CGFloat = 60
    static let separatorLineCardCellHeight: CGFloat = 1
    static let separatorLineSettingsCellHeight: CGFloat = 5
}

struct ParserKeys {

    static let answerKey = "answer"
    static let answersKey = "answers"
    static let correctAnswerKey = "correctAnswer"
    static let countKey = "count"
    static let createdAtKey = "createdAt"
    static let idKey = "id"
    static let optionsKey = "options"
    static let pollKey = "poll"
    static let resultsKey = "results"
    static let sharedKey = "shared"
    static let stateKey = "state"
    static let textKey = "text"
    static let typeKey = "type"
    static let updatedAtKey = "updatedAt"
}

struct RequestKeys {
    
    static let accessTokenKey = "accessToken"
    static let answerChoicesKey = "answerChoices"
    static let answerIDKey = "answerID"
    static let choiceKey = "choice"
    static let correctAnswerKey = "correctAnswer"
    static let countKey = "count"
    static let googleIDKey = "googleID"
    static let letterKey = "letter"
    static let optionsKey = "options"
    static let pollKey = "poll"
    static let sharedKey = "shared"
    static let textKey = "text"
    static let typeKey = "type"
    static let userTypeKey = "userType"
}

struct StringConstants {
    static let dateFormat = "MMM dd yyyy"
    static let multipleChoice = "Multiple Choice"
}

struct IntegerConstants {
    static let maxOptionsForAdminMC = 4
    static let maxOptionsForMemberMC = 4
    static let maxQuestionCharacterCount = 120
    static let validCodeLength = 6
}

struct UserDefault {

    static func set(value: Any?, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getBoolValue(for key: String) -> Bool {
        if let boolValue = UserDefaults.standard.value(forKey: key) as? Bool {
            return boolValue
        }
        return false
    }

    struct Keys {
        static let displayOnboarding = "displayOnboarding"
    }
}
    
struct App {

    /// The app version within the App Store (e.g. "1.4.2") [String value of `CFBundleShortVersionString`]
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

}

struct Device {
    static let id: String = {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            return deviceId
        } else {
            return UUID().uuidString
        }
    }()

    static let modelName = UIDevice.current.model
    
    private init() {}
}

struct Google {
    static let googleClientID = "43978214891-pk0scb60nvn2ofa5acccd58k79n4llkg.apps.googleusercontent.com"
    
    private init() {}
}
