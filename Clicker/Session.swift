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
    var socket: SocketIOClient!
    
    init(id: Int, delegate: SessionDelegate? = nil) {
        self.id = id
        self.delegate = delegate
        let url = URL(string: "http://localhost:\(id)")!
        self.socket = SocketIOClient(socketURL: url, config: [.log(true), .compress])
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET CONNECTED BALSJDLASKJDLK!")
            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET DISCONNECTED BALSJDLASKJDLK!")
            self.delegate?.sessionDisconnected()
        }
        
        socket.on("server/question/start") { data, ack  in
            print("server started question")
            self.socket.emit("student/question/start", data)
        }
        
        socket.on("student/question/start") { data, ack in
            print("DETECTED QUESTION START!!!")
            guard let questionAttrs = data[0] as? JSON else {
                return
            }
            print(questionAttrs)
            let question = Question(json: questionAttrs)
            self.delegate?.beginQuestion(question)
        }
        
        socket.on("student/question/end") { data, ack in
            guard let questionAttrs = data[0] as? JSON else {
                return
            }
            let question = Question(json: questionAttrs)
            self.delegate?.endQuestion(question)
        }
        socket.connect()
    }
    
    // private lazy var         TEMPP
//    var socket: SocketIOClient = {
//        //let url = URL(string: "http://localhost:8080/lecture/\(id)")!
//        let url = URL(string: "http://localhost:\(id)")!
//        let socket = SocketIOClient(socketURL: url, config: [.log(true), .compress])
//
//        socket.on(clientEvent: .connect) { data, ack in
//            print("SOCKET CONNECTED BALSJDLASKJDLK!")
//            self.delegate?.sessionConnected()
//        }
//
//        socket.on(clientEvent: .disconnect) { data, ack in
//            self.delegate?.sessionDisconnected()
//        }
//
//        socket.on("student/question/start") {[weak self] data, ack in
//            guard let questionAttrs = data[0] as? JSON else {
//                return
//            }
//            let question = Question(json: questionAttrs)
//            self?.delegate?.beginQuestion(question)
//        }
//
//        socket.on("student/question/end") {[weak self] data, ack in
//            guard let questionAttrs = data[0] as? JSON else {
//                return
//            }
//            let question = Question(json: questionAttrs)
//            self?.delegate?.endQuestion(question)
//        }
//
//        return socket
//    }()
}

