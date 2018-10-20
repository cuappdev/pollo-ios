//
//  PollsCell+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 8/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn
import IGListKit
import UIKit

extension PollsCell: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let pollTypeModel = pollTypeModel, let sessions = pollTypeModel.sessions else { return [] }
        if !sessions.isEmpty {
            return sessions.reversed()
        }
        let emptyStateType: EmptyStateType = .pollsViewController(pollType: pollTypeModel.pollType)
        return [EmptyStateModel(type: emptyStateType)]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Session {
            return SessionSectionController(delegate: self)
        } else {
            return EmptyStateSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return ActivityIndicatorView()
    }
    
}

extension PollsCell: SessionSectionControllerDelegate {
    
    func sessionSectionControllerShouldOpenSession(sectionController: SessionSectionController, session: Session, withCell cell: PollPreviewCell) {
        let userRole: UserRole = pollTypeModel.pollType == .created ? .admin : .member
        delegate.pollsCellShouldOpenSession(session: session, userRole: userRole, withCell: cell)
    }
    
    func sessionSectionControllerShouldEditSession(sectionController: SessionSectionController, session: Session) {
        let userRole: UserRole = pollTypeModel.pollType == .created ? .admin : .member
        delegate.pollsCellShouldEditSession(session: session, userRole: userRole)
    }
    
}
