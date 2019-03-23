//
//  HeaderCell.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/11/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class HeaderCell: UICollectionViewCell {
    
    // MARK: View vars
    var header: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        header = UILabel()
        header.font = ._18SemiboldFont
        header.textAlignment = .center
        header.textColor = .white
        contentView.addSubview(header)
    }
    
    private func setupConstraints() {
        header.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
    }
    
    func configure(for header: HeaderModel) {
       self.header.text = header.title
    }
}
 
