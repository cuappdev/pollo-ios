//
//  PollSettingsSectionController.swift
//  Pollo
//
//  Created by Mathew Scullin on 3/12/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollSettingsSectionControllerDelegate: class {
    func pollSettingsSectionControllerDidUpdate(_ sectionController: PollSettingsSectionController, to newValue: Bool)
}

class PollSettingsSectionController: ListSectionController {
    
    // MARK: - Data vars
    weak var delegate: PollSettingsSectionControllerDelegate?
    var settingsModel: PollsSettingModel!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 96
    let padding: CGFloat = 16
    
    init(delegate: PollSettingsSectionControllerDelegate?) {
        super.init()
        self.inset = UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0)
        self.delegate = delegate
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
        cell.delegate = self
        return cell
    }
    
    override func didUpdate(to object: Any) {
        settingsModel = object as? PollsSettingModel
    }

}

// MARK: - SettingCellDelegate
extension PollSettingsSectionController: SettingCellDelegate {

    func settingCellDidUpdate(_ cell: SettingCell, to newValue: Bool) {
        delegate?.pollSettingsSectionControllerDidUpdate(self, to: newValue)
    }

}
