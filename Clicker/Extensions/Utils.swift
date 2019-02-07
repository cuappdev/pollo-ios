//
//  Utils.swift
//  Clicker
//
//  Created by Kevin Chan on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - General Utils
// CONVERT INT TO MC OPTIONS
func intToMCOption(_ intOption: Int) -> String {
    return String(Character(UnicodeScalar(intOption + Int(("A" as UnicodeScalar).value))!))
}

// GET MMM dd yyyy OF TODAY
// Ex) Sep 29 2018, Oct 02 2018
func getTodaysDate() -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = StringConstants.dateFormat
    return formatter.string(from: Date())
}

func getLatestActivity(latestActivityTimestamp: Double, code: String, role: UserRole) -> String {
    var latestActivity = "Last live "
    let today: Date = Date()
    let latestActivityDate: Date = Date(timeIntervalSince1970: latestActivityTimestamp)
    if today.days(from: latestActivityDate) == 0 {
        if today.hours(from: latestActivityDate) == 0 {
            let numMinutesAgo = today.minutes(from: latestActivityDate) == 0 ? 1 : today.minutes(from: latestActivityDate)
            let suffix = numMinutesAgo == 1 ? "minute" : "minutes"
            latestActivity += "\(numMinutesAgo) \(suffix) ago"
        } else {
            let suffix = today.hours(from: latestActivityDate) == 1 ? "hr" : "hrs"
            latestActivity += "\(today.hours(from: latestActivityDate)) \(suffix) ago"
        }
    } else {
        if today.days(from: latestActivityDate) < 7 {
            let suffix = today.days(from: latestActivityDate) == 1 ? "day" : "days"
            latestActivity += "\(today.days(from: latestActivityDate)) \(suffix) ago"
        } else {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            latestActivity += String(formatter.string(from: latestActivityDate).split(separator: ",")[0])
        }
    }
    if role == .admin {
        latestActivity = code + "  ·  " + latestActivity
    }
    return latestActivity
}

// USER DEFAULTS
func encodeObjForKey(obj: Any, key: String) {
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
    UserDefaults.standard.set(encodedData, forKey: key)
}

func decodeObjForKey(key: String) -> Any {
    let decodedData = UserDefaults.standard.value(forKey: key) as! Data
    return NSKeyedUnarchiver.unarchiveObject(with: decodedData)!
}

// MARK: - Utils for Polls
func buildPollOptionsModelType(from poll: Poll, userRole: UserRole) -> PollOptionsModelType {
    var type: PollOptionsModelType
    switch poll.questionType {
    case .freeResponse:
        type = buildFROptionModelType(from: poll)
    case .multipleChoice:
        switch poll.state {
        case .live, .ended:
            switch userRole {
            case .member:
                type = buildMCChoiceModelType(from: poll)
            case .admin:
                type = buildMCResultModelType(from: poll)
            }
        case .shared:
            type = buildMCResultModelType(from: poll)
        }
    }
    return type
}

func buildPollOptionsModel(from poll: Poll, userRole: UserRole) -> PollOptionsModel {
    let type = buildPollOptionsModelType(from: poll, userRole: userRole)
    return PollOptionsModel(type: type, pollState: poll.state)
}

func calculatePollOptionsCellHeight(for pollOptionsModel: PollOptionsModel, userRole: UserRole) -> CGFloat {
    
    let verticalPadding: CGFloat = LayoutConstants.pollOptionsPadding * 2 + LayoutConstants.interItemPadding
    var optionModels: [OptionModel]
    var optionHeight: CGFloat
    var maximumNumberVisibleOptions: Int
    switch pollOptionsModel.type {
    case .mcResult(let mcResultModels):
        optionModels = mcResultModels
        optionHeight = LayoutConstants.mcOptionCellHeight
        maximumNumberVisibleOptions = userRole == .admin ? IntegerConstants.maxOptionsForAdminMC : IntegerConstants.maxOptionsForMemberMC
    case .mcChoice(let mcChoiceModels):
        optionModels = mcChoiceModels
        optionHeight = LayoutConstants.mcOptionCellHeight
        maximumNumberVisibleOptions = userRole == .admin ? IntegerConstants.maxOptionsForAdminMC : IntegerConstants.maxOptionsForMemberMC
    case .frOption(let frOptionModels):
        optionModels = frOptionModels
        if optionModels.isEmpty {
            return LayoutConstants.noResponsesSpace
        }
        optionHeight = LayoutConstants.frOptionCellHeight
        maximumNumberVisibleOptions = userRole == .admin ? IntegerConstants.maxOptionsForAdminFR : IntegerConstants.maxOptionsForMemberFR
    }
    let numOptions = min(optionModels.count, maximumNumberVisibleOptions)
    let optionsHeight: CGFloat = CGFloat(numOptions) * optionHeight
    return verticalPadding + optionsHeight
}

// MARK: - Helpers
private func buildFROptionModelType(from poll: Poll) -> PollOptionsModelType {
    var frOptionModels: [FROptionModel] = poll.getFRResultsArray().map { (answerId, option, count) -> FROptionModel in
        // Need to subtract 1 from count to get numUpvoted because submitting the response doesn't count as upvote
        let numUpvoted = count - 1
        let didUpvote = poll.userDidUpvote(answerId: answerId)
        return FROptionModel(option: option, answerId: answerId, numUpvoted: numUpvoted, didUpvote: didUpvote)
    }
    frOptionModels.sort { (frOptionModelA, frOptionModelB) -> Bool in
        return frOptionModelA.numUpvoted > frOptionModelB.numUpvoted
    }
    return .frOption(optionModels: frOptionModels)
}

private func buildMCChoiceModelType(from poll: Poll) -> PollOptionsModelType {
    let mcChoiceModels = poll.options.enumerated().map { (index, option) -> MCChoiceModel in
        var isSelected: Bool
        if let selected = poll.getSelected() as? String {
            isSelected = poll.userDidSelect(mcChoice: intToMCOption(index)) || selected == option
        } else {
            isSelected = poll.userDidSelect(mcChoice: intToMCOption(index))
        }
        return MCChoiceModel(option: option, isSelected: isSelected)
    }
    return .mcChoice(choiceModels: mcChoiceModels)
}

func formatResults(results: [String : JSON]) -> [String : PollResult] {
    var pollResults = [String : PollResult]()
    results.forEach { (key, value) in
        let text = value[ParserKeys.textKey].stringValue
        let count = value[ParserKeys.countKey].intValue
        pollResults[key] = PollResult(text: text, count: count)
    }
    return pollResults
}

func formatAnswers(answers: [String : JSON]) -> [String : PollAnswer] {
    var pollAnswers = [String : PollAnswer]()
    answers.forEach { (key, value) in
        if let answerIdsJson = value.array {
            var answerIds = [Int]()
            answerIdsJson.forEach({ json in
                answerIds.append(json.intValue)
            })
            pollAnswers[key] = PollAnswer(answer: nil, answerIds: answerIds)
        } else if let answer = value.string {
            pollAnswers[key] = PollAnswer(answer: answer, answerIds: nil)
        }
    }
    return pollAnswers
}

func buildMCResultModelType(from poll: Poll) -> PollOptionsModelType {
    var mcResultModels: [MCResultModel] = []
    let totalNumResults = Float(poll.getTotalResults())
    poll.options.enumerated().forEach { (index, option) in
        let mcOptionKey = intToMCOption(index)
        if let result = poll.results[mcOptionKey] {
            let option = result.text
            let numSelected = result.count
            let percentSelected = totalNumResults > 0 ? Float(numSelected) / totalNumResults : 0
            var isSelected = false
            if let selected = poll.getSelected() as? String {
                isSelected = mcOptionKey == selected || selected == option
            }
            let resultModel = MCResultModel(option: option, numSelected: Int(numSelected), percentSelected: percentSelected, isSelected: isSelected, choiceIndex: index)
            mcResultModels.append(resultModel)
        }
    }
    // We should always have at least 2 choices.
    // Thus, if mcResultModels is empty, that means poll.results is empty.
    // This should only happen for the admin/poll/start socket route in which
    // the poll is still live which makes sense that we do not have any results yet.
    if mcResultModels.isEmpty {
        poll.options.enumerated().forEach { (index, option) in
            let resultModel = MCResultModel(option: option, numSelected: 0, percentSelected: 0.0, isSelected: false, choiceIndex: index)
            mcResultModels.append(resultModel)
        }
    }
    return .mcResult(resultModels: mcResultModels)
}
