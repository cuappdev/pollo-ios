//
//  GroupControlsInfoModel.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/10/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

class GroupControlsInfoModel {
    
    var numMembers: Int
    var numPolls: Int
    var code: String
    let identifier = UUID().uuidString
    
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
