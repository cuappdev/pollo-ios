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
    var pollsCellDelegate: PollsCellDelegate {get}
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
        guard let context = collectionContext else { return .zero }
        // This is the size of the whole collection view
        return context.containerSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollsCell.self, for: self, at: index) as! PollsCell
        cell.configureWith(pollTypeModel: pollTypeModel, delegate: delegate.pollsCellDelegate)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pollTypeModel = object as? PollTypeModel
    }

    // MARK: - Updates
    func update(with sessions: [Session]) {
        var updatedSessions: [Session] = []
        sessions.forEach { session in
            if let oldSessions = pollTypeModel.sessions {
                if let sameOldSession = oldSessions.first(where: { oldSession -> Bool in
                    return session.code == oldSession.code
                }) {
                    updatedSessions.append(sameOldSession)
                    return
                }
            }
            updatedSessions.append(session)
        }
        pollTypeModel.sessions = updatedSessions
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? PollsCell else { return }
        cell.update(with: updatedSessions)
    }
    
    // MARK: - ListDisplayDelegate
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        delegate.sectionControllerWillDisplayPollType(sectionController: self, pollType: pollTypeModel.pollType)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}

    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}

    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
}
