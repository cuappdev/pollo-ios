//
//  SeparatorLineCell.swift
//  Pollo
//
//  Created by Kevin Chan on 9/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class SeparatorLineCell: UICollectionViewCell {
    
    // MARK: - View vars
    var lineView: UIView!
    
    // MARK: - Data vars
    var model: SeparatorLineModel!
    
    // MARK: - Constants
    let lineViewHeight: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lineView = UIView()
        lineView.backgroundColor = .clickerGrey5
        contentView.addSubview(lineView)
    }
    
    override func updateConstraints() {
        lineView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()  
            make.height.equalTo(lineViewHeight)
        }
        super.updateConstraints()
    }
    
    func configure(with model: SeparatorLineModel) {
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
