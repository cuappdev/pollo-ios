//
//  PollBuilderMCOptionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollBuilderMCOptionSectionControllerDelegate: class {
    
    func pollBuilderSectionControllerDidDeleteOption(index: Int)
    func pollBuilderSectionControllerDidUpdateIsCorrect(option: String, index: Int, isCorrect: Bool)
    func pollBuilderSectionControllerDidUpdateOption(option: String, index: Int, isCorrect: Bool)
    func pollBuilderSectionControllerShouldAddOption()
    
}

class PollBuilderMCOptionSectionController: ListSectionController {
    
    // MARK: - Data vars
    var mcOptionModel: PollBuilderMCOptionModel!
    weak var delegate: PollBuilderMCOptionSectionControllerDelegate?
    
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
        case .newOption:
            let createMCOptionCell = collectionContext?.dequeueReusableCell(of: CreateMCOptionCell.self, for: self, at: index) as! CreateMCOptionCell
            createMCOptionCell.configure(for: mcOptionModel, delegate: self)
            cell = createMCOptionCell
        case .addOption:
            let addMoreOptionCell = collectionContext?.dequeueReusableCell(of: AddMoreOptionCell.self, for: self, at: index) as! AddMoreOptionCell
            addMoreOptionCell.configure(with: delegate)
            cell = addMoreOptionCell
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        mcOptionModel = object as? PollBuilderMCOptionModel
    }
    
}

extension PollBuilderMCOptionSectionController: CreateMCOptionCellDelegate {

    func createMCOptionCellDidUpdateTextField(index: Int, text: String, isCorrect: Bool) {
        delegate?.pollBuilderSectionControllerDidUpdateOption(option: text, index: index, isCorrect: isCorrect)
    }

    func createMCOptionCellDidUpdateIsCorrect(index: Int, text: String, isCorrect: Bool) {
        delegate?.pollBuilderSectionControllerDidUpdateIsCorrect(option: text, index: index, isCorrect: isCorrect)
    }
    
    func createMCOptionCellDidDeleteOption(index: Int) {
        delegate?.pollBuilderSectionControllerDidDeleteOption(index: index)
    }
    
}
