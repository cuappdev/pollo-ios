//
//  Socket.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SocketIO

class Socket {
    let id: String
    var delegates: [SocketDelegate] = [SocketDelegate]()
    var socket: SocketIOClient
    var manager: SocketManager
    
    init(id: String, userType: String) {
        self.id = id
        
        let url = URL(string: hostURL)!
        manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams(["userType": userType, "googleId": User.currentUser?.id])])
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { data, ack in
            self.delegates.forEach{ $0.sessionConnected() }
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegates.forEach { $0.sessionConnected() }
        }
        
        socket.on("user/poll/start") { data, ack in
            print(data)
            guard let json = data[0] as? [String:Any], let pollJSON = json["poll"] as? [String:Any], let questionJSON = json["poll"] as? [String:Any] else {
                return
            }
            let poll = Poll(json: pollJSON)
            self.delegates.forEach { $0.pollStarted(poll) }
        }
        
        socket.on("user/poll/end") { data, ack in
            guard let json = data[0] as? [String:Any], let pollJSON = json["poll"] as? [String:Any] else {
                return
            }
            let poll = Poll(json: pollJSON)
            self.delegates.forEach { $0.pollEnded(poll) }
        }
        
        socket.on("user/poll/results") { data, ack in
            print(data)
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentState(json: json)
            self.delegates.forEach { $0.receivedResults(currentState) }
        }
        
        socket.on("user/session/save") { data, ack in
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let session = Session(json: json)
            self.delegates.forEach { $0.saveSession(session) }
        }
        
        socket.on("admin/poll/updateTally") { data, ack in
            print(data)
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentState(json: json)
            self.delegates.forEach { $0.updatedTally(currentState) }
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
