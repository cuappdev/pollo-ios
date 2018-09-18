//
//  OptionModel.swift
//  Clicker
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

class OptionModel {
    
    var option: String
    var isAnswer: Bool
    
    init(option: String, isAnswer: Bool) {
        self.option = option
        self.isAnswer = isAnswer
    }
    
}
