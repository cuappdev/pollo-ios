//
//  PollsCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import GoogleSignIn

enum PollType {
    case created
    case joined
}

class PollsCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, GIDSignInDelegate {
    
    var pollsTableView: UITableView!
    let pollPreviewIdentifier = "pollPreviewCellID"
    var sessions: [Session] = []
    var pollType: PollType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        GIDSignIn.sharedInstance().delegate = self
        getPollSessions()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pollPreviewIdentifier) as! PollPreviewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.2
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        pollsTableView = UITableView()
        pollsTableView.delegate = self
        pollsTableView.dataSource = self
        pollsTableView.register(PollPreviewCell.self, forCellReuseIdentifier: pollPreviewIdentifier)
        pollsTableView.separatorStyle = .none
        addSubview(pollsTableView)
    }
    
    func setupConstraints() {
        pollsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // GET POLL SESSIONS
    func getPollSessions() {
        guard let _ = User.userSession else {
            return
        }
        let role: UserRole
        if (pollType == .created) {
            role = .admin
        } else {
            role = .member
        }
        GetPollSessions(role: String(describing: role)).make()
            .done { sessions in
                self.sessions = sessions
                DispatchQueue.main.async { self.pollsTableView.reloadData() }
            } .catch { error in
                print(error)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userId = user.userID // For client-side use only!
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let netId = email?.split(separator: "@")[0]
            User.currentUser = User(id: Float(userId!)!, name: fullName!, netId: String(netId!), givenName: givenName!, familyName: familyName!, email: email!)
            
            UserAuthenticate(userId: userId!, givenName: givenName!, familyName: familyName!, email: email!).make()
                .done { userSession in
                    print(userSession)
                    User.userSession = userSession
                    self.getPollSessions()
                } .catch { error in
                    print(error)
            }
            
            UserDefaults.standard.set( UserDefaults.standard.integer(forKey: "significantEvents") + 2, forKey:"significantEvents")
            window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
