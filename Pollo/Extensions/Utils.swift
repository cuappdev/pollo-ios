//
//  Utils.swift
//  Pollo
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

func convertUnixStringToDate(_ unixString: String) -> Date {
    guard let dateAsDouble = Double(unixString) else { return Date() }
    let unixDate = Date(timeIntervalSince1970: dateAsDouble)
    return unixDate
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

func getNavigationTitleView(primaryText: String, primaryTextHeight: CGFloat, secondaryText: String, secondaryTextHeight: CGFloat, userRole: UserRole?, delegate: NavigationTitleViewDelegate?) -> NavigationTitleView {
    let primaryTextWidth = primaryText.width(
        withConstrainedHeight: primaryTextHeight,
        font: ._16SemiboldFont
    )
    let secondaryTextWidth = secondaryText.width(
        withConstrainedHeight: secondaryTextHeight,
        font: ._12SemiboldFont
    )
    let buttonWidth = primaryTextWidth > secondaryTextWidth
        ? primaryTextWidth
        : secondaryTextWidth
    let navigationTitleView = NavigationTitleView(frame: .zero, buttonWidth: buttonWidth)
    if let userRole = userRole, let delegate = delegate {
        navigationTitleView.configure(primaryText: primaryText, secondaryText: secondaryText, userRole: userRole, delegate: delegate)
    } else {
        navigationTitleView.configure(primaryText: primaryText, secondaryText: secondaryText)
    }
    return navigationTitleView
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
    switch poll.state {
    case .live, .ended:
        switch userRole {
        case .member:
            type = buildMCChoiceModelType(from: poll)
        case .admin:
            type = buildMCResultModelType(from: poll, userRole: userRole)
        }
    case .shared:
        type = buildMCResultModelType(from: poll, userRole: userRole)
    }
    return type
}

func buildPollOptionsModel(from poll: Poll, userRole: UserRole) -> PollOptionsModel {
    let type = buildPollOptionsModelType(from: poll, userRole: userRole)
    return PollOptionsModel(type: type, pollState: poll.state)
}

func calculatePollOptionsCellHeight(for pollOptionsModel: PollOptionsModel) -> CGFloat {
    var optionModels: [OptionModel]
    switch pollOptionsModel.type {
    case .mcResult(let mcResultModels):
        optionModels = mcResultModels
    case .mcChoice(let mcChoiceModels):
        optionModels = mcChoiceModels
    }
    let optionsHeight: CGFloat = CGFloat(optionModels.count) * LayoutConstants.mcOptionCellHeight
    return LayoutConstants.pollOptionsBottomPadding + optionsHeight
}

private func buildMCChoiceModelType(from poll: Poll) -> PollOptionsModelType {
    let mcChoiceModels = poll.answerChoices.enumerated().map { (index, option) -> MCChoiceModel in
        let isSelected = poll.userDidSelect(mcChoice: index)
        return MCChoiceModel(option: option.text, isSelected: isSelected)
    }
    return .mcChoice(choiceModels: mcChoiceModels)
}

func formatResults(results: [String: JSON]) -> [String: PollResult] {
    var pollResults = [String: PollResult]()
    results.forEach { (key, value) in
        let index = value[ParserKeys.indexKey].intValue
        let text = value[ParserKeys.textKey].stringValue
        let count = value[ParserKeys.countKey].intValue
        pollResults[key] = PollResult(index: index, text: text, count: count)
    }
    return pollResults
}

func getNumSelected(poll: Poll, choice: PollResult, userRole: UserRole) -> Int {
    if userRole == .admin || poll.state == .shared {
        return choice.count ?? 0
    }
    return 0
}

func buildMCResultModelType(from poll: Poll, userRole: UserRole) -> PollOptionsModelType {
    var mcResultModels: [MCResultModel] = []
    let totalNumResults = Float(poll.getTotalResults(for: userRole))
    var choiceIndex = 0
    poll.answerChoices.forEach { choice in
        let numSelected = getNumSelected(poll: poll, choice: choice, userRole: userRole)
        let index = choice.index
        let percentSelected = totalNumResults > 0 ? Float(numSelected) / totalNumResults : 0
        var isSelected = false
        if let selected = poll.getSelected() {
            isSelected = index == selected
        }
        let resultModel = MCResultModel(option: choice.text, numSelected: numSelected, percentSelected: percentSelected, isSelected: isSelected, choiceIndex: choiceIndex)
        mcResultModels.append(resultModel)
        choiceIndex += 1
    }
    return .mcResult(resultModels: mcResultModels)
}
