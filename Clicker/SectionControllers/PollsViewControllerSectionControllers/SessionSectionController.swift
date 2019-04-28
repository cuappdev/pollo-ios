//
//  SessionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol SessionSectionControllerDelegate: class {
    
    func sessionSectionControllerShouldEditSession(sectionController: SessionSectionController, session: Session)
    func sessionSectionControllerShouldOpenSession(sectionController: SessionSectionController, session: Session, withCell: PollPreviewCell)
    
}

class SessionSectionController: ListSectionController {
    
    // MARK: - Data vars
    var session: Session!
    weak var delegate: SessionSectionControllerDelegate?
    
    // MARK: - Constants
    let cellHeight: CGFloat = 82.5
    
    init(delegate: SessionSectionControllerDelegate) {
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
        let cell = collectionContext?.dequeueReusableCell(of: PollPreviewCell.self, for: self, at: index) as! PollPreviewCell
        cell.configure(for: session, delegate: self)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        session = object as? Session
    }
    
    override func didSelectItem(at index: Int) {
        let cell = collectionContext?.cellForItem(at: index, sectionController: self) as! PollPreviewCell
        cell.isSelected = true
        collectionContext?.deselectItem(at: index, sectionController: self, animated: true)
        delegate?.sessionSectionControllerShouldOpenSession(sectionController: self, session: session, withCell: cell)
    }
    
    override func didDeselectItem(at index: Int) {
        let cell = collectionContext?.cellForItem(at: index, sectionController: self) as! PollPreviewCell
        cell.isSelected = false
    }

    

}

extension SessionSectionController: PollPreviewCellDelegate {
    
    func pollPreviewCellShouldEditSession() {
        delegate?.sessionSectionControllerShouldEditSession(sectionController: self, session: session)
    }
    
}
