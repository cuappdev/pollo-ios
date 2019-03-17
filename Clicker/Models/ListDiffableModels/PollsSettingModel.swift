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

class PollsSettingModel {
    
    var title: String
    var description: String
    var type: SettingType
    var isEnabled: Bool
    let identifier = UUID().uuidString
    
    init(title: String, description: String, type: SettingType, isEnabled: Bool) {
        self.title = title
        self.description = description
        self.type = type
        self.isEnabled = isEnabled
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
