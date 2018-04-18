//
//  Socket.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SocketIO

class Socket {
    let id: Int
    var delegate: SocketDelegate?
    var socket: SocketIOClient
    var manager: SocketManager
    
    init(id: Int, userType: String, delegate: SocketDelegate? = nil) {
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
        
        socket.on("server/question/start") { data, ack  in
            self.socket.emit("student/question/start", data)
        }
        
        socket.on("user/question/start") { data, ack in
            guard let json = data[0] as? [String:Any], let questionJSON = json["question"] as? [String:Any] else {
                return
            }
            let question = Question(json: questionJSON)
            self.delegate?.questionStarted(question)
        }
        
        socket.on("user/question/end") { data, ack in
            guard let json = data[0] as? [String:Any], let questionJSON = json["question"] as? [String:Any] else {
                return
            }
            let question = Question(json: questionJSON)
            self.delegate?.questionEnded(question)
        }
        
        socket.on("user/question/results") { data, ack in
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentState(json: json)
            self.delegate?.receivedResults(currentState)
            
        }
        
        socket.on("user/poll/save") { data, ack in
            guard let json = data[0] as? [String:Any] else {
                return
            }
//            let poll = Poll(json: json)
//            self.delegate?.savePoll(poll)
        }
        
        socket.on("admin/question/updateTally") { data, ack in
            guard let json = data[0] as? [String:Any] else {
                return
            }
            let currentState = CurrentState(json: json)
            self.delegate?.updatedTally(currentState)
        }
        
        socket.connect()
    }
}
