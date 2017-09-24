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

        return socket
    }()
}
