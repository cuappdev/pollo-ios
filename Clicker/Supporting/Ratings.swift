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
    
    static let launchThreshold = 5
    
    class func updateNumAppLaunches() {
        let runs = getNumAppLaunches() + 1
        UserDefaults.standard.set(runs, forKey: "NUMBER_OF_LAUNCHES")
        UserDefaults.standard.synchronize()
    }
    
    class func getNumAppLaunches() -> Int {
        if let numLaunches = UserDefaults.standard.value(forKey: "NUMBER_OF_LAUNCHES") as? Int {
            return numLaunches
        }
        return 0
    }
    
    class func shouldPromptReview() -> Bool{
        let numLaunches = getNumAppLaunches()
        return numLaunches >= launchThreshold
    }
    
    class func promptReview(){
        if #available(iOS 10.3, *)  {
            if shouldPromptReview() {
                SKStoreReviewController.requestReview()
            }
        }
    }
}
