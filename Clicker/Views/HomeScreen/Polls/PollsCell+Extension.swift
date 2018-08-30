//
//  PollsCell+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 8/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn
import UIKit

extension PollsCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.pollPreviewIdentifier) as! PollPreviewCell
        cell.session = sessions[sessions.count - indexPath.row - 1]
        cell.index = indexPath.row
        cell.delegate = self
        cell.updateLabels()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return pollPreviewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let session: Session = sessions[sessions.count - indexPath.row - 1]
        
        GetSortedPolls(id: session.id).make()
            .done { pollsDateArray in
                let userRole: UserRole = self.pollType == .created ? .admin : .member
                let cardController = CardController(pollsDateArray: pollsDateArray, session: session, userRole: userRole)
                self.delegate.shouldPushCardController(cardController: cardController)
            } .catch { error in
                print(error)
        }
    }

}

extension PollsCell: PollPreviewCellDelegate {
    
    func shouldEditPoll(atIndex index: Int) {
        let session = sessions[sessions.count - index - 1]
        self.delegate.shouldEditSession(session: session)
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
