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

    private lazy var socket: SocketIOClient = {
        let url = URL(string: "http://localhost:8080/lecture/\(id)")!
        let socket = SocketIOClient(socketURL: url, config: [.log(true), .compress])

        socket.on(clientEvent: .connect) { data, ack in
            self.delegate?.sessionConnected()
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on("beginLecture") {[weak self] data, ack in
            self.delegate?.beginLecture()
        }
        
        socket.on("postQuestion") {[weak self] data, ack in
            self.delegate?.postQuestion()
        }
        
        socket.on("endLecture") {[weak self] data, ack in
            self.delegate?.endLecture()
        }

        return socket
    }()
}
