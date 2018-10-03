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
    var delegate: SocketDelegate
    var socket: SocketIOClient
    var manager: SocketManager
    
    init(id: String, userRole: UserRole, delegate: SocketDelegate) {
        self.id = id
        self.delegate = delegate
        let url = URL(string: Keys.hostURL.value)!
        if let googleId = User.currentUser?.id {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams([RequestKeys.userTypeKey: userRole.rawValue, RequestKeys.googleIdKey: googleId])])
        } else {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams([RequestKeys.userTypeKey: userRole.rawValue])])
        }
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { data, ack in
            self.delegate.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegate.sessionDisconnected()
        }
        
        socket.on(Routes.userStart) { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json[ParserKeys.pollKey] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .live)
            self.delegate.pollStarted(poll, userRole: .member)
        }
        
        socket.on(Routes.userEnd) { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json[ParserKeys.pollKey] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .ended)
            self.delegate.pollEnded(poll, userRole: .member)
        }
        
        socket.on(Routes.userShare) { data, ack in
            guard let dict = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegate.receivedResults(currentState)
        }
        
        socket.on(Routes.adminStart) { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json[ParserKeys.pollKey] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .live)
            self.delegate.pollStarted(poll, userRole: .admin)
        }
        
        socket.on(Routes.adminUpdateTally) { data, ack in
            guard let dict = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegate.updatedTally(currentState)
        }
        
        socket.on(Routes.adminEnded) { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json[ParserKeys.pollKey] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .ended)
            self.delegate.pollEnded(poll, userRole: .admin)
        }
        
        socket.on(Routes.count) { data, ack in
            guard let json = data[0] as? [String:Any], let count = json[ParserKeys.countKey] as? Int else {
                return
            }
            self.delegate.receivedUserCount(count)
        }
        
        socket.connect()
    }

    func updateDelegate(_ delegate: SocketDelegate) {
        self.delegate = delegate
    }
    
}
