//
//  SocketDelegate.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

protocol SocketDelegate {
    func sessionConnected()
    func sessionDisconnected()
    
    // USER RECEIVES
    func questionStarted(_ question: Question)
    func questionEnded(_ question: Question)
    func receivedResults(_ currentState: CurrentState)
    func saveSession(_ session: Session)
    
    // ADMIN RECEIVES
    func updatedTally(_ currentState: CurrentState)
}
