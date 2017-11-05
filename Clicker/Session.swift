//
//  Session.swift
//  Clicker
//
//  Created by Kevin Chan on 10/30/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import SocketIO
import SwiftyJSON

class Session {
    let id: Int
    var delegate: SessionDelegate?
    
    init(id: Int, delegate: SessionDelegate? = nil) {
        self.id = id
        self.delegate = delegate
    }
    
    private lazy var socket: SocketIOClient = {
        let url = URL(string: "http://localhost:8080/lecture/\(id)")!
        let socket = SocketIOClient(socketURL: url, config: [.log(true), .compress])
        
        socket.on(clientEvent: .connect) { data, ack in
            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on("student/question/start") {[weak self] data, ack in
            guard let questionAttrs = data[0] as? JSON else {
                return
            }
            let question = Question(json: questionAttrs)
            self?.delegate?.beginQuestion(question)
        }
        
        socket.on("student/question/end") {[weak self] data, ack in
            self?.delegate?.endQuestion()
        }
        
        return socket
    }()
}

