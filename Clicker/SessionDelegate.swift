//
//  SessionDelegate.swift
//  Clicker
//
//  Created by Kevin Chan on 10/30/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import SocketIO

protocol SessionDelegate {
    func sessionConnected()
    func sessionDisconnected()
    func beginQuestion(_ question: Question)
    func endQuestion(_ question: Question)
    func postResponses(_ answers: [Answer])
    func sendResponse(_ answer: Answer)
}
