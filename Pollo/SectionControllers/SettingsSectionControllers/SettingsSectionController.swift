//
//  SettingsSectionController.swift
//  Pollo
//
//  Created by eoin on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol LogOutSectionControllerDelegate: class {
    func logOutSectionControllerButtonWasTapped()
}

class SettingsSectionController: ListSectionController {
    
    var settingsDataModel: SettingsDataModel!
    
    // MARK: Data vars
    weak var delegate: LogOutSectionControllerDelegate?
    
    // MARK: Layout constants
    let aboutInfoCellHeight: CGFloat = 110.0
    let accountInfoCellHeight: CGFloat = 80.0
    let buttonCellHeight: CGFloat = 39.5
    let feedbackInfoCellHeight: CGFloat = 130
    let linkCellHeight: CGFloat = 39.5
    
    init(delegate: LogOutSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        switch settingsDataModel.state {
        case .info:
            var cellHeight: CGFloat
            switch settingsDataModel.title {
            case "Account":
                cellHeight = accountInfoCellHeight
            case "About":
                cellHeight = aboutInfoCellHeight
            default:
                cellHeight = feedbackInfoCellHeight
            }
            return CGSize(width: containerSize.width, height: cellHeight)
        case .link:
            return CGSize(width: containerSize.width, height: linkCellHeight)
        case .button:
            return CGSize(width: containerSize.width, height: buttonCellHeight)
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
        case .button:
            let cell = collectionContext?.dequeueReusableCell(of: SettingsLogOutButtonCell.self, for: self, at: index) as! SettingsLogOutButtonCell
            cell.configureWith(settingsDataModel: settingsDataModel)
            cell.delegate = self
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        settingsDataModel = object as? SettingsDataModel
    }

}

// MARK: - LogoutButtonCellDelegate
extension SettingsSectionController: LogoutButtonCellDelegate {
    
    func logOutButtonCellWasTapped() {
        delegate?.logOutSectionControllerButtonWasTapped()
    }
    
}
