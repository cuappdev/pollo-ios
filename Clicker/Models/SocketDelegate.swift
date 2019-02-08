//
//  SocketDelegate.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

protocol SocketDelegate: class {
    func sessionConnected()
    func sessionDisconnected()
    func receivedUserCount(_ count: Int)
    func pollStarted(_ poll: Poll, userRole: UserRole)
    func pollEnded(_ poll: Poll, userRole: UserRole)
    
    // USER RECEIVES
    func receivedResults(_ currentState: CurrentState)
    func receivedResultsLive(_ currentState: CurrentState)
    
    // ADMIN RECEIVES
    func updatedTally(_ currentState: CurrentState)
    func updatedTallyLive(_ currentState: CurrentState)
}
