//
//  PastSessionHeader.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/1/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class PastSessionHeader: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEWS
    let sectionHeaderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 180, height: 29))
        label.text = "Past Sessions"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func addViews() {
        addSubview(sectionHeaderLabel)
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints(){
        let leadingConstraints = NSLayoutConstraint(item: sectionHeaderLabel, attribute: .leadingMargin, relatedBy: .equal, toItem: sectionHeaderLabel.superview, attribute: .leadingMargin, multiplier: 1.0, constant: 18)
        
        let trailingConstraints = NSLayoutConstraint(item: sectionHeaderLabel, attribute:
            .trailingMargin, relatedBy: .equal, toItem: sectionHeaderLabel.superview,
                             attribute: .trailingMargin, multiplier: 1.0, constant: -18)
        
        let topConstraints = NSLayoutConstraint(item: sectionHeaderLabel, attribute: .topMargin, relatedBy: .equal, toItem: sectionHeaderLabel.superview, attribute: .topMargin, multiplier: 1.0, constant: 27)
        
        NSLayoutConstraint.activate([leadingConstraints, trailingConstraints, topConstraints])
    }

}
