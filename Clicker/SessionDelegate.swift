import SocketIO

protocol SessionDelegate {
    func sessionConnected()
    func sessionDisconnected()
    func beginQuestion(_ question: Question)
    func endQuestion(_ question: Question)
    func postResponses(_ answers: [Answer])
    func sendResponse(_ answer: Answer)
}
