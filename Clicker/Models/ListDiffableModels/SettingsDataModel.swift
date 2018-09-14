//
//  SettingsDataModel.swift
//  Clicker
//
//  Created by eoin on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum SettingsDataState {
    case link // just a link to something
    case info // a title and some information
}

class SettingsDataModel {
    
    let identifier = UUID().uuidString
    var state: SettingsDataState
    var title: String
    var description: String?
    
    init(state: SettingsDataState, title: String, description: String? = nil) {
        self.state = state
        self.title = title
        self.description = description
    }
    
}

extension SettingsDataModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? SettingsDataModel else { return false }
        return identifier == object.identifier
    }
    
    
}
