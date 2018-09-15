//
//  SettingsSectionController.swift
//  Clicker
//
//  Created by eoin on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class SettingsSectionController: ListSectionController {
    
    var settingsDataModel: SettingsDataModel!
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        switch settingsDataModel.state {
        case .info:
            return CGSize(width: containerSize.width, height: settingsDataModel.title == "About" ? 110 : 87)
        case .link:
            return CGSize(width: containerSize.width, height: 39.5)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let settingsDataModel = settingsDataModel else {
            print("settingsDataModel not initialized")
            return UICollectionViewCell()
        }
        switch settingsDataModel.state {
        case .info:
            let cell = collectionContext?.dequeueReusableCell(of: SettingsInfoCell.self, for: self, at: index) as! SettingsInfoCell
            cell.configureWith(settingsDataModel: settingsDataModel)
            return cell
        case .link:
            let cell = collectionContext?.dequeueReusableCell(of: SettingsLinkCell.self, for: self, at: index) as! SettingsLinkCell
            cell.configureWith(settingsDataModel: settingsDataModel)
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        settingsDataModel = object as? SettingsDataModel
    }

}
