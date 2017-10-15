//
//  Constants.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/13/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Screen {
        static let width: CGFloat = (UIApplication.shared.keyWindow?.frame.width)!
        static let height: CGFloat = (UIApplication.shared.keyWindow?.frame.height)!
    }
    
    struct Headers {
        struct Height {
            static let liveSession: CGFloat = 44.5
            static let pastSession: CGFloat = 53.5
        }
    }
}
