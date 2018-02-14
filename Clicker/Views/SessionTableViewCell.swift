//
//  SessionTableViewCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class SessionTableViewCell: UITableViewCell {
    
    var containerView: UIView!
    var sessionLabel: UILabel!
    var sessionText: String! {
        didSet {
            print(sessionText)
            sessionLabel.text = sessionText
        }
    }
    var emptyView: UIView!
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = .clear
        
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        addSubview(containerView)
        
        sessionLabel = UILabel(frame: .zero)
        sessionLabel.font = UIFont._18RegularFont
        containerView.addSubview(sessionLabel)
        
        emptyView = UIView()
        emptyView.backgroundColor = .clear
        addSubview(emptyView)
        
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.snp.updateConstraints { make in
            print(frame.height)
            make.width.equalToSuperview()
            make.height.equalTo(frame.height - 5)
            make.top.equalToSuperview()
        }
        
        sessionLabel.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(38.5)
            make.right.equalToSuperview()
        }
        
        emptyView.snp.updateConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

