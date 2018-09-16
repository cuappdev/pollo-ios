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
    var delegates: [SocketDelegate] = [SocketDelegate]()
    var socket: SocketIOClient
    var manager: SocketManager
    
    init(id: String, userType: String) {
        self.id = id
        
        let url = URL(string: Keys.hostURL.value)!
        if let googleId = User.currentUser?.id {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams(["userType": userType, "googleId": googleId])])
        } else {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams(["userType": userType])])
        }
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { data, ack in
            self.delegates.forEach{ $0.sessionConnected() }
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegates.forEach { $0.sessionDisconnected() }
        }
        
        socket.on("user/poll/start") { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json["poll"] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .live)
            self.delegates.forEach { $0.pollStarted(poll) }
        }
        
        socket.on("user/poll/end") { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json["poll"] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .ended)
            self.delegates.forEach { $0.pollEnded(poll, userRole: .member) }
        }
        
        socket.on("user/poll/results") { data, ack in
            guard let dict = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegates.forEach { $0.receivedResults(currentState) }
        }
        
        socket.on("admin/poll/updateTally") { data, ack in
            guard let dict = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentStateParser.parseItem(json: JSON(dict))
            self.delegates.forEach { $0.updatedTally(currentState) }
        }
        
        socket.on("admin/poll/ended") { data, ack in
            guard let json = data[0] as? [String:Any], let pollDict = json["poll"] as? [String:Any] else {
                return
            }
            let poll = PollParser.parseItem(json: JSON(pollDict), state: .ended)
            self.delegates.forEach { $0.pollEnded(poll, userRole: .admin) }
        }
        
        socket.on("user/count") { data, ack in
            guard let json = data[0] as? [String:Any], let count = json["count"] as? Int else {
                return
            }
            self.delegates.forEach { $0.receivedUserCount(count) }
        }
        
        socket.connect()
    }
    
    func addDelegate(_ delegate: SocketDelegate) {
        self.delegates.append(delegate)
    }
}
