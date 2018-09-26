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
        if !sessions.isEmpty {
            return sessions.reversed()
        }
        guard let pollType = pollType else { return [] }
        let emptyStateType: EmptyStateType = .pollsViewController(pollType: pollType)
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
        return nil
    }
    
}

extension PollsCell: SessionSectionControllerDelegate {
    
    func sessionSectionControllerShouldOpenSession(sectionController: SessionSectionController, session: Session) {
        let userRole: UserRole = pollType == .created ? .admin : .member
        delegate.pollsCellShouldOpenSession(session: session, userRole: userRole)
    }
    
    func sessionSectionControllerShouldEditSession(sectionController: SessionSectionController, session: Session) {
        let userRole: UserRole = pollType == .created ? .admin : .member
        delegate.pollsCellShouldEditSession(session: session, userRole: userRole)
    }
    
}

extension PollsCell: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userId = user.userID // For client-side use only!
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let netId = email?.split(separator: "@")[0]
            User.currentUser = User(id: userId!, name: fullName!, netId: String(netId!), givenName: givenName!, familyName: familyName!, email: email!)
            
            UserAuthenticate(userId: userId!, givenName: givenName!, familyName: familyName!, email: email!).make()
                .done { userSession in
                    User.userSession = userSession
                    self.getPollSessions()
                } .catch { error in
                    print(error)
            }
            
            UserDefaults.standard.set( UserDefaults.standard.integer(forKey: Identifiers.significantEventsIdentifier) + 2, forKey:Identifiers.significantEventsIdentifier)
            window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}
