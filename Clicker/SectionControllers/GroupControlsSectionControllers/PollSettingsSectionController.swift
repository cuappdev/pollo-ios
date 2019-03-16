//
//  PollSettingsSectionController.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/12/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit

class PollSettingsSectionController: ListSectionController {
    
    // MARK: - Data vars
    var settingsModel: PollsSettingModel!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 96
    let padding: CGFloat = 16
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width - (2 * padding), height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: SettingCell.self, for: self, at: index) as! SettingCell
        cell.configure(for: settingsModel)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        settingsModel = object as? PollsSettingModel
    }

}