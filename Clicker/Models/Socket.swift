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
    var delegate: SocketDelegate?
    var socket: SocketIOClient
    var manager: SocketManager
    
    init(id: String, userType: String, delegate: SocketDelegate? = nil) {
        self.id = id
        self.delegate = delegate
        
        let url = URL(string: hostURL)!
        manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams(["userType": userType, "googleId": User.currentUser?.id])])
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { data, ack in
            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on("user/poll/start") { data, ack in
            print(data)
            guard let json = data[0] as? [String:Any], let questionJSON = json["poll"] as? [String:Any] else {
                return
            }
            let question = Question(json: questionJSON)
            self.delegate?.questionStarted(question)
        }
        
        socket.on("user/poll/end") { data, ack in
            guard let json = data[0] as? [String:Any], let questionJSON = json["poll"] as? [String:Any] else {
                return
            }
            let question = Question(json: questionJSON)
            self.delegate?.questionEnded(question)
        }
        
        socket.on("user/poll/results") { data, ack in
            print(data)
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentState(json: json)
            self.delegate?.receivedResults(currentState)
        }
        
        socket.on("user/session/save") { data, ack in
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let session = Session(json: json)
            self.delegate?.saveSession(session)
        }
        
        socket.on("admin/poll/updateTally") { data, ack in
            print(data)
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentState(json: json)
            self.delegate?.updatedTally(currentState)
        }
        
        socket.connect()
    }
}
