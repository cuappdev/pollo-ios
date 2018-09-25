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

// GET MM/DD/YYYY OF TODAY
func getTodaysDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yy"
    return formatter.string(from: Date())
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
func buildPollOptionsModel(from poll: Poll, userRole: UserRole) -> PollOptionsModel {
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
    return PollOptionsModel(type: type, pollState: poll.state)
}

func calculatePollOptionsCellHeight(for pollOptionsModel: PollOptionsModel) -> CGFloat {
    let verticalPadding: CGFloat = LayoutConstants.pollOptionsVerticalPadding * 2
    var optionModels: [OptionModel]
    var optionHeight: CGFloat
    switch pollOptionsModel.type {
    case .mcResult(let mcResultModels):
        optionModels = mcResultModels
        optionHeight = LayoutConstants.mcOptionCellHeight
    case .mcChoice(let mcChoiceModels):
        optionModels = mcChoiceModels
        optionHeight = LayoutConstants.mcOptionCellHeight
    case .frOption(let frOptionModels):
        optionModels = frOptionModels
        optionHeight = LayoutConstants.frOptionCellHeight
    }
    let maximumNumberVisibleOptions = 6
    let numOptions = min(optionModels.count, maximumNumberVisibleOptions)
    let optionsHeight: CGFloat = CGFloat(numOptions) * optionHeight
    return verticalPadding + optionsHeight
}

// MARK: - Helpers
private func buildFROptionModelType(from poll: Poll) -> PollOptionsModelType {
    let frOptionModels: [FROptionModel] = poll.getFRResultsArray().map { (option, count) -> FROptionModel in
        // numUpvoted is the count - 1 because submitting a response does not count as an upvote
        let numUpvoted = count - 1
        return FROptionModel(option: option, isAnswer: option == poll.answer, numUpvoted: numUpvoted, didUpvote: false)
    }
    return .frOption(optionModels: frOptionModels)
}

private func buildMCChoiceModelType(from poll: Poll) -> PollOptionsModelType {
    let mcChoiceModels = poll.options.map {
        return MCChoiceModel(option: $0, isAnswer: $0 == poll.answer)
    }
    return .mcChoice(choiceModels: mcChoiceModels)
}

func buildMCResultModelType(from poll: Poll) -> PollOptionsModelType {
    var mcResultModels: [MCResultModel] = []
    let totalNumResults = Float(poll.getTotalResults())
    poll.options.enumerated().forEach { (index, option) in
        let mcOptionKey = intToMCOption(index)
        if let infoDict = poll.results[mcOptionKey] {
            guard let option = infoDict[ParserKeys.textKey].string, let numSelected = infoDict[ParserKeys.countKey].int else { return }
            let percentSelected = totalNumResults > 0 ? Float(numSelected) / totalNumResults : 0
            let isAnswer = option == poll.answer
            let resultModel = MCResultModel(option: option, numSelected: Int(numSelected), percentSelected: percentSelected, isAnswer: isAnswer)
            mcResultModels.append(resultModel)
        }
    }
    return .mcResult(resultModels: mcResultModels)
}
