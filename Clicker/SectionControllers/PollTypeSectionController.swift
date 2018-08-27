//
//  PollTypeSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

protocol PollTypeSectionControllerDelegate {
    var editSessionDelegate: EditSessionDelegate {get}
    func sectionControllerWillDisplayPollType(sectionController:PollTypeSectionController, pollType: PollType)
}

class PollTypeSectionController: ListSectionController, ListDisplayDelegate {
    
    var pollTypeModel: PollTypeModel!
    var delegate: PollTypeSectionControllerDelegate!
    
    init(delegate: PollTypeSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        // This is the size of the whole collection view
        return (collectionContext?.containerSize)!
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollsCell.self, for: self, at: index) as! PollsCell
        cell.pollType = pollTypeModel.pollType
        cell.editSessionDelegate = delegate.editSessionDelegate
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pollTypeModel = object as? PollTypeModel
    }
    
    // MARK: - ListDisplayDelegate
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        delegate.sectionControllerWillDisplayPollType(sectionController: self, pollType: pollTypeModel.pollType)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
}
