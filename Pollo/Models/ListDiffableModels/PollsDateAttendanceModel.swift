//
//  PollsDateModel.swift
//  Pollo
//
//  Created by Kevin Chan on 11/8/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

class PollsDateAttendanceModel {

    let identifier = UUID().uuidString
    var isSelected: Bool
    var model: PollsDateModel

    init(model: PollsDateModel, isSelected: Bool) {
        self.isSelected = isSelected
        self.model = model
    }

}

extension PollsDateAttendanceModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? PollsDateAttendanceModel else { return false }
        return identifier == object.identifier
    }
}
