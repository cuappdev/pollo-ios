import SocketIO

protocol SessionDelegate {
    func sessionConnected()
    func sessionDisconnected()
    func beginLecture(_ lectureId: String)
    func endLecture()
    func beginQuestion(_ question: Question)
    func endQuestion(_ question: Question)
    func postResponses(_ answers: [Answer])
    func sendResponse(_ answer: Answer)
}
