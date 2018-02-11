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
        self.socket = SocketIOClient(socketURL: url, config: [.log(true), .compress, .connectParams(["userType": "student"])])
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET CONNECTED")
            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on("server/question/start") { data, ack  in
            self.socket.emit("student/question/start", data)
        }
        
        socket.on("student/question/start") { data, ack in
            guard let json = data[0] as? [String:Any], let questionJSON = json["question"] as? [String:Any],
                let questionIDString = questionJSON["id"] as? String else {
                    return
            }
            let questionID = Int(questionIDString)
//            GetQuestion(id: "\(questionID!)" ).make()
//                .then { question -> Void in
//                    self.delegate?.beginQuestion(question)
//                }.catch { error in
//                    print(error)
//            }
        }
        
        socket.on("student/question/end") { data, ack in
            guard let json = data[0] as? [String:Any], let questionJSON = json["question"] as? [String:Any],
                let questionIDString = questionJSON["id"] as? String else {
                    return
            }
            let questionID = Int(questionIDString)
//            GetQuestion(id: "\(questionID!)" ).make()
//                .then { question -> Void in
//                    self.delegate?.endQuestion(question)
//                }.catch { error in
//                    print(error)
//            }
        }
        socket.connect()
    }
}
