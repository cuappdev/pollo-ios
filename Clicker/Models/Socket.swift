//
//  Socket.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SocketIO
import SwiftyJSON

class Socket {

    let id: String
    weak var delegate: SocketDelegate?
    var socket: SocketIOClient
    var manager: SocketManager
    
    init(id: String, userRole: UserRole, delegate: SocketDelegate) {
        self.id = id
        self.delegate = delegate
        #if DEV_SERVER
        let urlString = "http://\(Keys.hostURL.value)"
        #else
        let urlString = "https://\(Keys.hostURL.value)3000"
        #endif
        guard let url = URL(string: urlString) else { fatalError("Bad url") }
        if let googleID = User.currentUser?.id {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams([RequestKeys.userTypeKey: userRole.rawValue, RequestKeys.googleIDKey: googleID])])
        } else {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams([RequestKeys.userTypeKey: userRole.rawValue])])
        }
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { _, _ in
            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { _, _ in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on(Routes.userStart) { data, _ in
            guard let json = data[0] as? [String: Any], let pollDict = json[ParserKeys.pollKey] as? [String: Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .live)
            self.delegate?.pollStarted(poll, userRole: .member)
        }
        
        socket.on(Routes.userEnd) { data, _ in
            guard let json = data[0] as? [String: Any], let pollDict = json[ParserKeys.pollKey] as? [String: Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .ended)
            self.delegate?.pollEnded(poll, userRole: .member)
        }
        
        socket.on(Routes.userResults) { data, _ in
            guard let dict = data[0] as? [String: Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegate?.receivedResults(currentState)
        }

        socket.on(Routes.userResultsLive) { data, _ in
            guard let dict = data[0] as? [String: Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegate?.receivedResultsLive(currentState)
        }
        
        // We only receive admin/poll/start when the user is an admin, rejoins a session, and there is a live poll
        socket.on(Routes.adminStart) { data, _ in
            guard let json = data[0] as? [String: Any], let pollDict = json[ParserKeys.pollKey] as? [String: Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .live)
            self.delegate?.pollStarted(poll, userRole: .admin)
        }
        
        socket.on(Routes.adminUpdateTally) { data, _ in
            guard let dict = data[0] as? [String: Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegate?.updatedTally(currentState)
        }

        socket.on(Routes.adminUpdateTallyLive) { data, _ in
            guard let dict = data[0] as? [String: Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegate?.updatedTallyLive(currentState)
        }
        
        socket.on(Routes.adminEnded) { data, _ in
            guard let json = data[0] as? [String: Any], let pollDict = json[ParserKeys.pollKey] as? [String: Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .ended)
            self.delegate?.pollEnded(poll, userRole: .admin)
        }
        
        socket.on(Routes.count) { data, _ in
            guard let json = data[0] as? [String: Any], let count = json[ParserKeys.countKey] as? Int else {
                return
            }
            self.delegate?.receivedUserCount(count)
        }

        socket.connect()
    }

    func updateDelegate(_ delegate: SocketDelegate) {
        self.delegate = delegate
    }
    
}
