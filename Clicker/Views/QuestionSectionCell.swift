//
//  QuestionSectionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 3/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol QuestionDelegate {
    func inFollowUpQuestion()
}

class QuestionSectionCell: UICollectionViewCell, UITextFieldDelegate {
 
    //MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clickerGrey4
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
