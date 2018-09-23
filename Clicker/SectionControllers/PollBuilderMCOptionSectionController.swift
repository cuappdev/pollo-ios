//
//  PollBuilderMCOptionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollBuilderMCOptionSectionControllerDelegate {
    
    func pollBuilderSectionControllerShouldAddOption(sectionController: PollBuilderMCOptionSectionController)
    func pollBuilderSectionControllerDidUpdateOption(sectionController: PollBuilderMCOptionSectionController, option:String, index: Int)
    func pollBuilderSectionControllerDidDeleteOption(sectionController: PollBuilderMCOptionSectionController, index: Int)
    
}

class PollBuilderMCOptionSectionController: ListSectionController {
    
    // MARK: - Data vars
    var mcOptionModel: PollBuilderMCOptionModel!
    var delegate: PollBuilderMCOptionSectionControllerDelegate
    
    // MARK: - Constants
    let cellHeight: CGFloat = 53
    
    init(delegate: PollBuilderMCOptionSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        switch mcOptionModel.type {
        case .newOption(_):
            let createMCOptionCell = collectionContext?.dequeueReusableCell(of: CreateMCOptionCell.self, for: self, at: index) as! CreateMCOptionCell
            createMCOptionCell.configure(for: mcOptionModel, delegate: self)
            cell = createMCOptionCell
        case .addOption:
            cell = collectionContext?.dequeueReusableCell(of: AddMoreOptionCell.self, for: self, at: index) as! AddMoreOptionCell
        }
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        mcOptionModel = object as? PollBuilderMCOptionModel
    }
    
    override func didSelectItem(at index: Int) {
        switch mcOptionModel.type {
        case .addOption:
            delegate.pollBuilderSectionControllerShouldAddOption(sectionController: self)
        case .newOption(option: _, index: _):
            return
        }
    }
    
}

extension PollBuilderMCOptionSectionController: CreateMCOptionCellDelegate {
    
    func createMCOptionCellDidUpdateTextField(index: Int, text: String) {
        delegate.pollBuilderSectionControllerDidUpdateOption(sectionController: self, option: text, index: index)
    }
    
    func createMCOptionCellDidDeleteOption(index: Int) {
        delegate.pollBuilderSectionControllerDidDeleteOption(sectionController: self, index: index)
    }
    
}
