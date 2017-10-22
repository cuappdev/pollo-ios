import SocketIO

protocol SessionDelegate {
    func sessionConnected()
    func sessionDisconnected()
    func beginLecture()
    func postQuestion()
    func endLecture()
}
