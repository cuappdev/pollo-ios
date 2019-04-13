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
    weak var delegate: SocketDelegate?
    var socket: SocketIOClient
    var manager: SocketManager

    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    init(id: String, userRole: UserRole, delegate: SocketDelegate) {
        self.id = id
        self.delegate = delegate
        var urlString = "https://\(Keys.hostURL.value)"
        #if LOCAL_SERVER
        urlString = "http://localhost:3000"
        #endif
        guard let url = URL(string: urlString) else { fatalError("Bad url") }
        if let googleID = User.currentUser?.id {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams([RequestKeys.userTypeKey: userRole.rawValue, RequestKeys.googleIDKey: googleID])])
        } else {
            manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams([RequestKeys.userTypeKey: userRole.rawValue])])
        }
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { _, _ in
            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { _, _ in
            self.delegate?.sessionDisconnected()
        }
        
        socket.on(Routes.userStart) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollStarted(poll, userRole: .member)
        }
        
        socket.on(Routes.userEnd) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollEnded(poll, userRole: .member)
        }

        socket.on(Routes.userDelete) { data, _ in
            guard let pollID = data[0] as? Int else { return }
            self.delegate?.pollDeleted(pollID, userRole: .member)
        }

        socket.on(Routes.userDeleteLive) { _, _ in
            self.delegate?.pollDeletedLive()
        }
        
        socket.on(Routes.userResults) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.receivedResults(poll, userRole: .member)
        }

        socket.on(Routes.userResultsLive) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.receivedResultsLive(poll, userRole: .member)
        }
        
        // We only receive admin/poll/start when the user is an admin, rejoins a session, and there is a live poll
        socket.on(Routes.adminStart) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollStarted(poll, userRole: .admin)
        }
        
        socket.on(Routes.adminUpdateTally) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.updatedTally(poll, userRole: .admin)
        }

        socket.on(Routes.adminUpdateTallyLive) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.updatedTallyLive(poll, userRole: .admin)
        }
        
        socket.on(Routes.adminEnded) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]) else { return }
            guard let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollEnded(poll, userRole: .admin)
        }

        socket.connect()
    }

    func updateDelegate(_ delegate: SocketDelegate) {
        self.delegate = delegate
    }
    
}
