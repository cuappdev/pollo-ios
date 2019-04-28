//
//  PollsSettingModel.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/12/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

enum SettingType {
    case filter
    case liveQuestions
    case location
}

class PollsSettingModel: NSCopying {

    let identifier = UUID().uuidString
    var description: String
    var isEnabled: Bool
    var title: String
    var type: SettingType

    init(title: String, description: String, type: SettingType, isEnabled: Bool) {
        self.description = description
        self.isEnabled = isEnabled
        self.title = title
        self.type = type
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PollsSettingModel(title: title, description: description, type: type, isEnabled: isEnabled)
        return copy
    }

}

extension PollsSettingModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HeaderModel else { return false }
        return identifier == object.identifier
    }

}
