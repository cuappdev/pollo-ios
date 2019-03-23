//
//  PollsDateModel.swift
//  Clicker
//
//  Created by Kevin Chan on 8/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

struct PollsResponse: Codable {

    var correctAnswer: String?
    var id: Int
    var results: [String: PollResult]
    var shared: Bool
    var text: String
    var type: String

}

struct GetSortedPollsResponse: Codable {

    // Seconds since 1970
    var date: String
    var polls: [PollsResponse]

    /// Swift Date representation of `date` sent from backend
    lazy var dateValue: Date = {
        return convertUnixStringToDate(date)
    }()

}

class PollsDateModel: Codable {

    // Seconds since 1970
    let identifier = UUID().uuidString
    var date: String
    var polls: [Poll]

    /// Swift Date representation of `date` sent from backend
    lazy var dateValue: Date = { [weak self] in
        guard let `self` = self else { return Date() }
        return convertUnixStringToDate(self.date)
    }()

    init(date: String, polls: [Poll]) {
        self.date = date
        self.polls = polls
    }

}

extension PollsDateModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? PollsDateModel else { return false }
        return identifier == object.identifier
    }
}
