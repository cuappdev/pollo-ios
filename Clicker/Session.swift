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
        print("PORT NUMBER IS \(id)")
        self.socket = SocketIOClient(socketURL: url, config: [.log(true), .compress, .connectParams(["userType": "student"])])
        
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
//          data[0] as? [String:Any] =  ["question": {
//                id = 4;
//                text = "Is clique-pod the best pod in AppDev?";
//                type = "MULTIPLE_CHOICE";
//          }]
            guard let json = data[0] as? [String:Any], let questionJSON = json["question"] as? [String:Any],
                let questionID = questionJSON["id"] as? Int else {
                    print("failed to convert to json")
                    return
            }
            print(questionID)
            GetQuestion(id: "\(questionID)" ).make()
                .then { question -> Void in
                    print("retrieved question")
                    self.delegate?.beginQuestion(question)
                }.catch { error in
                    print(error)
            }
            
        }
        
        socket.on("student/question/end") { data, ack in
            print("DETECTED QUESTION END")
            print(data[0])
            guard let json = data[0] as? [String:Any], let questionJSON = json["question"] as? [String:Any],
                let questionID = questionJSON["id"] as? Int else {
                    print("failed to convert to json")
                    return
            }
            print(questionID)
            GetQuestion(id: "\(questionID)" ).make()
                .then { question -> Void in
                    print("retrieved question")
                    self.delegate?.endQuestion(question)
                }.catch { error in
                    print(error)
            }
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

