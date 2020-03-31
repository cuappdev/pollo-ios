//
//  Socket.swift
//  Pollo
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import NotificationBannerSwift
import SocketIO
import SwiftyJSON

class Socket {

    let id: String
    weak var delegate: SocketDelegate?
    var manager: SocketManager
    var socket: SocketIOClient

    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    init(id: String, delegate: SocketDelegate) {
        self.id = id
        self.delegate = delegate
        var urlString = "https://\(Keys.hostURL)"
        #if LOCAL_SERVER
        urlString = "http://localhost:3000"
        #endif
        guard let url = URL(string: urlString) else { fatalError("Bad url") }
        guard let accessToken = User.userSession?.accessToken else { fatalError("No access token") }
        manager = SocketManager(socketURL: url, config: [.log(true), .reconnects(true), .reconnectAttempts(3), .reconnectWait(2), .reconnectWaitMax(10), .compress, .connectParams([RequestKeys.accessTokenKey: accessToken])])
        
        socket = manager.socket(forNamespace: "/\(id)")
        
        socket.on(clientEvent: .connect) { _, _ in
            let banner = NotificationBanner.connectedBanner()
            BannerController.shared.show(banner)

            self.delegate?.sessionConnected()
        }
        
        socket.on(clientEvent: .disconnect) { _, _ in
            let banner = NotificationBanner.disconnectedBanner()
            banner.onTap = { [weak self] in
                guard let self = self else { return }
                self.manualReconnect()
            }
            BannerController.shared.show(banner)

            self.delegate?.sessionDisconnected()
        }

        socket.on(clientEvent: .reconnect) { ( _, _) in
            let banner = NotificationBanner.reconnectingBanner()
            BannerController.shared.show(banner)

            self.delegate?.sessionReconnecting()
        }

        socket.on(Routes.userStart) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollStarted(poll, userRole: .member)
        }
        
        socket.on(Routes.userEnd) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollEnded(poll, userRole: .member)
        }

        socket.on(Routes.userDelete) { data, _ in
            guard let pollID = data[0] as? String else { return }
            self.delegate?.pollDeleted(pollID, userRole: .member)
        }

        socket.on(Routes.userDeleteLive) { _, _ in
            self.delegate?.pollDeletedLive()
        }
        
        socket.on(Routes.userResults) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.receivedResults(poll, userRole: .member)
        }
        
        // We only receive admin/poll/start when the user is an admin, rejoins a session, and there is a live poll
        socket.on(Routes.adminStart) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollStarted(poll, userRole: .admin)
        }

        socket.on(Routes.adminUpdates) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.updatedTally(poll, userRole: .admin)
        }
        
        socket.on(Routes.adminUpdateTally) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.updatedTally(poll, userRole: .admin)
        }

        socket.on(Routes.adminUpdateTallyLive) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.updatedTallyLive(poll, userRole: .admin)
        }
        
        socket.on(Routes.adminEnded) { socketData, _ in
            guard let data = try? JSONSerialization.data(withJSONObject: socketData[0]), let poll = try? self.jsonDecoder.decode(Poll.self, from: data) else { return }
            self.delegate?.pollEnded(poll, userRole: .admin)
        }

        socket.connect()
    }

    /// Manually reconnect socket to the server
    func manualReconnect() {
        let banner = NotificationBanner.reconnectingBanner()
        BannerController.shared.show(banner)

        socket.connect(timeoutAfter: 10) { [weak self] in
            guard let self = self else { return }
            let banner = NotificationBanner.disconnectedBanner()
            banner.onTap = { [weak self] in
                guard let `self` = self else { return }
                self.manualReconnect()
            }
            BannerController.shared.show(banner)
        }
    }

    func updateDelegate(_ delegate: SocketDelegate?) {
        self.delegate = delegate
    }
    
}
