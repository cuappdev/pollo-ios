//
//  Session.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/22/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import SocketIO

class Session {
    let id: Int
    var delegate: SessionDelegate?
    
    init(id: Int, delegate: SessionDelegate? = nil) {
        self.id = id
        self.delegate = delegate
    }
    
    static var socket: SocketIOClient? {
        guard let socket = _socket else {
            //fatalError("Error: current user doesn't exist")
            return nil
        }
        return socket
    }
    
    private lazy var _socket: SocketIOClient = {
        let url = URL(string: "http://localhost:8080/lecture/\(id)")!
        let socket = SocketIOClient(socketURL: url, config: [.log(true), .compress])

        socket.on(clientEvent: .connect) { data, ack in
            self.delegate?.sessionConnected()
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on("begin_lecture") {[weak self] data, ack in
            guard let lectureId = data[0] as? String else {
                return
            }
            self.delegate?.beginLecture(profId, date)
        }
        
        socket.on("end_lecture") {[weak self] data, ack in
            self.delegate?.endLecture()
        }
        
        socket.on("begin_question") {[weak self] data, ack in
            guard let questionAttrs = data[0] as? JSON else {
                return
            }
            let question = Question(json: questionAttrs)
            self.delegate?.beginQuestion(question: question)
        }
        
        socket.on("end_question") {[weak self] data, ack in
            self.delegate?.endQuestion()
        }
        
        socket.on("post_responses") {[weak self] data, ack in
            self.delegate?.postResponses()
        }
        
        // socket.emit("join_lecture", lectureId)
        
        // socket.emit("send_response", reponse)
        
        return socket
    }()
}
