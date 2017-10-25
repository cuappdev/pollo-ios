import SocketIO

protocol SessionDelegate {
    func sessionConnected()
    func sessionDisconnected()
    func beginLecture(_ profId: Int, _ date: String)
    func endLecture()
    func beginQuestion(_ question: Question)
    func endQuestion()
    func postResponses(_ answers: [Answer])
    func joinLecture(_ lectureId: String)
    func sendResponse(_ answer: Answer)
}
