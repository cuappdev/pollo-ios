//
//  Utils.swift
//  Clicker
//
//  Created by Kevin Chan on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

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

func calculatePollOptionsCellHeight(for pollOptionsModel: PollOptionsModel, state: CardControllerState) -> CGFloat {
    let verticalPadding: CGFloat = LayoutConstants.pollOptionsVerticalPadding * 2
    var optionModels: [OptionModel]
    var optionHeight: CGFloat
    let isHorizontal = state == .horizontal
    switch pollOptionsModel.type {
    case .mcResult(resultModels: let mcResultModels):
        optionModels = mcResultModels
        optionHeight = isHorizontal ? LayoutConstants.horizontalMCOptionCellHeight : LayoutConstants.verticalMCOptionCellHeight
    case .mcChoice(choiceModels: let mcChoiceModels):
        optionModels = mcChoiceModels
        optionHeight = isHorizontal ? LayoutConstants.horizontalMCOptionCellHeight : LayoutConstants.verticalMCOptionCellHeight
    case .frOption(optionModels: let frOptionModels):
        optionModels = frOptionModels
        optionHeight = isHorizontal ? LayoutConstants.horizontalFROptionCellHeight : LayoutConstants.verticalFROptionCellHeight
    }
    let maximumNumberVisibleOptions = 6
    let numOptions = min(optionModels.count, maximumNumberVisibleOptions)
    let optionsHeight: CGFloat = CGFloat(numOptions) * optionHeight
    return verticalPadding + optionsHeight
}

// MARK: - Helpers
private func buildFROptionModelType(from poll: Poll) -> PollOptionsModelType {
    let frOptionModels: [FROptionModel] = poll.getFRResultsArray().map { (option, count) -> FROptionModel in
        return FROptionModel(option: option, isAnswer: option == poll.answer, numUpvoted: count, didUpvote: false)
    }
    return .frOption(optionModels: frOptionModels)
}

private func buildMCChoiceModelType(from poll: Poll) -> PollOptionsModelType {
    let mcChoiceModels = poll.options.map { return MCChoiceModel(option: $0, isAnswer: $0 == poll.answer) }
    return .mcChoice(choiceModels: mcChoiceModels)
}

func buildMCResultModelType(from poll: Poll) -> PollOptionsModelType {
    var mcResultModels: [MCResultModel] = []
    let totalNumResults = Float(poll.getTotalResults())
    poll.options.enumerated().forEach { (index, option) in
        let mcOptionKey = intToMCOption(index)
        if let infoDict = poll.results[mcOptionKey] as? [String:Any] {
            guard let option = infoDict["text"] as? String, let numSelected = infoDict["count"] as? Int else { return }
            let percentSelected = totalNumResults > 0 ? Float(numSelected) / totalNumResults : 0
            let isAnswer = option == poll.answer
            let resultModel = MCResultModel(option: option, numSelected: Int(numSelected), percentSelected: percentSelected, isAnswer: isAnswer)
            mcResultModels.append(resultModel)
        }
    }
    return .mcResult(resultModels: mcResultModels)
}
