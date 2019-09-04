//
//  GroupControlsInfoModel.swift
//  Pollo
//
//  Created by Mathew Scullin on 3/10/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit

class GroupControlsInfoModel {

    let identifier = UUID().uuidString
    var code: String
    var numMembers: Int
    var numPolls: Int

    init(numMembers: Int, numPolls: Int, code: String) {
        self.numMembers = numMembers
        self.numPolls = numPolls
        self.code = code
    }

}

extension GroupControlsInfoModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HeaderModel else { return false }
        return identifier == object.identifier
    }

}
