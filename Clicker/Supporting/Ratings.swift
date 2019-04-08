//
//  Ratings.swift
//  Clicker
//
//  Created by Lucy Xu on 3/24/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import StoreKit

class Ratings {
    
    static let shared = Ratings()
    let launchThreshold = 20
    let NUMBER_OF_LAUNCHES = "NUMBER_OF_LAUNCHES"
    
    private init() {}
    
    func updateNumAppLaunches() {
        let numLaunches = getNumAppLaunches() + 1
        UserDefaults.standard.set(numLaunches, forKey: NUMBER_OF_LAUNCHES)
        UserDefaults.standard.synchronize()
    }
    
    func getNumAppLaunches() -> Int {
        return UserDefaults.standard.value(forKey: NUMBER_OF_LAUNCHES) as? Int ?? 0
    }
    
    func shouldPromptReview() -> Bool {
        let numLaunches = getNumAppLaunches()
        return numLaunches >= launchThreshold
    }
    
    func promptReview() {
        if #available(iOS 10.3, *), shouldPromptReview() {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.set(0, forKey: NUMBER_OF_LAUNCHES)
            UserDefaults.standard.synchronize()
        }
    }
    
}
