//
//  SocketDelegate.swift
//  Pollo
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import NotificationBannerSwift

protocol SocketDelegate: class {

    /// Called when a connection is successfully established.
    func sessionConnected()
    /// Called when a socket is disconnected and a reconnect attempt will not be made.
    func sessionDisconnected()
    /// Called when a reconnect attempt is made.
    func sessionReconnecting()
    func pollEnded(_ poll: Poll, userRole: UserRole)
    func pollDeleted(_ pollID: String, userRole: UserRole)
    func pollDeletedLive()
    func pollStarted(_ poll: Poll, userRole: UserRole)
    
    // USER RECEIVES
    func receivedResults(_ poll: Poll, userRole: UserRole)
    func receivedResultsLive(_ poll: Poll, userRole: UserRole)
    
    // ADMIN RECEIVES
    func updatedTally(_ poll: Poll, userRole: UserRole)
    func updatedTallyLive(_ poll: Poll, userRole: UserRole)
}
