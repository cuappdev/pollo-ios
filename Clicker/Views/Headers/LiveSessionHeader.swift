//
//  LiveSessionHeader.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/1/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class LiveSessionHeader: UITableViewHeaderFooterView {

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
        label.text = "Live Sessions"
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
        sectionHeaderLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView).offset(18)
            make.right.equalTo(self.contentView).offset(18)
            make.top.equalTo(self.contentView).offset(18)
        }
    }
}
