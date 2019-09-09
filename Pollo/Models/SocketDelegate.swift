//
//  SocketDelegate.swift
//  Pollo
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

protocol SocketDelegate: class {

    func sessionConnected()
    func sessionDisconnected()
    func pollEnded(_ poll: Poll, userRole: UserRole)
    func pollDeleted(_ pollID: Int, userRole: UserRole)
    func pollDeletedLive()
    func pollStarted(_ poll: Poll, userRole: UserRole)
    func sessionErrored()
    
    // USER RECEIVES
    func receivedResults(_ poll: Poll, userRole: UserRole)
    func receivedResultsLive(_ poll: Poll, userRole: UserRole)
    func receivedFRFilter(_ pollFilter: PollFilter)
    
    // ADMIN RECEIVES
    func updatedTally(_ poll: Poll, userRole: UserRole)
    func updatedTallyLive(_ poll: Poll, userRole: UserRole)
}