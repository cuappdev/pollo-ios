//
//  SessionDelegate.swift
//  Clicker
//
//  Created by Kevin Chan on 10/30/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

protocol SessionDelegate {
    func sessionConnected()
    func sessionDisconnected()
    
    // USER RECEIVES
    func questionStarted(_ question: Question)
    func questionEnded(_ question: Question)
    func receivedResults(_ currentState: CurrentState)
    func savePoll(_ poll: Poll)
    
    // ADMIN RECEIVES
    func updatedTally(_ currentState: CurrentState)
}
