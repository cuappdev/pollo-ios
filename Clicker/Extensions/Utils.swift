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

// Get a User's Joined and Created Sessions using DispatchGroup
func getAllSessions(completion: @escaping ([Session], [Session]) -> Void) {
    let dispatchGroup = DispatchGroup()
    var joinedSessions: [Session] = []
    var createdSessions: [Session] = []
    
    // Get joined sessions
    dispatchGroup.enter()
    GetPollSessions(role: .member).make()
        .done { sessions in
            joinedSessions = sessions
            dispatchGroup.leave()
        }.catch { error in
            print(error)
            dispatchGroup.leave()
    }
    
    // Get created sessions
    dispatchGroup.enter()
    GetPollSessions(role: .admin).make()
        .done { sessions in
            createdSessions = sessions
            dispatchGroup.leave()
        }.catch { error in
            print(error)
            dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: .main) {
        completion(joinedSessions, createdSessions)
    }
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

func calculatePollOptionsCellHeight(for pollOptionsModel: PollOptionsModel) -> CGFloat {
    let verticalPadding: CGFloat = LayoutConstants.pollOptionsPadding * 2 + LayoutConstants.interItemPadding
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
    let frOptionModels: [FROptionModel] = poll.getFRResultsArray().map { (answerId, option, count) -> FROptionModel in
        let didUpvote = poll.userDidUpvote(answerId: answerId)
        return FROptionModel(option: option, isAnswer: option == poll.answer, numUpvoted: count, didUpvote: didUpvote)
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
    // We should always have at least 2 choices.
    // Thus, if mcResultModels is empty, that means poll.results is empty.
    // This should only happen for the admin/poll/start socket route in which
    // the poll is still live which makes sense that we do not have any results yet.
    if mcResultModels.isEmpty {
        poll.options.forEach { option in
            let resultModel = MCResultModel(option: option, numSelected: 0, percentSelected: 0.0, isAnswer: false)
            mcResultModels.append(resultModel)
        }
    }
    return .mcResult(resultModels: mcResultModels)
}
