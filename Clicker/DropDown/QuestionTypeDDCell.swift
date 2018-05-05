//
//  QuestionTypeDDCell.swift
//  Clicker
//
//  Created by eoin on 5/1/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import DropDown

class QuestionTypeDDCell: DropDownCell {

    var index: Int!
    var type: String!
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setup(index: Int, type: String) {
        self.index = index
        self.type = type
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        label = UILabel()
        if index == 0 {
            label.textColor = .clickerGreen
            label.font = ._16SemiboldFont
        } else {
            label.textColor = .clickerDeepBlack
            label.font = ._16RegularFont
        }
        label.text = type
        addSubview(label)
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            label.sizeToFit()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
