//
//  PastSessionHeader.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/13/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

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
        let label = UILabel(frame: .zero)
        label.text = "Past Sessions"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomBorder: CALayer = {
        let border = CALayer()
        border.frame = CGRect(x: 0.0, y: Constants.Headers.Height.pastSession, width: Constants.Screen.width, height: 0.5)
        border.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor
        return border
    }()
    
    func addViews() {
        addSubview(sectionHeaderLabel)
        contentView.layer.addSublayer(bottomBorder)
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints(){
        sectionHeaderLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(27)
        }
    }
}
