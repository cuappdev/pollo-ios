//
//  ViewAllCell.swift
//  Pollo
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class ViewAllCell: UICollectionViewCell {

    // MARK: - View vars
    var viewAllLabel: UILabel!

    // MARK: - Constants
    let viewAllText = "View All"

    override init(frame: CGRect) {
        super.init(frame: frame)

        viewAllLabel = UILabel()
        viewAllLabel.text = viewAllText
        viewAllLabel.textColor = .clickerGreen0
        viewAllLabel.font = ._16MediumFont
        contentView.addSubview(viewAllLabel)

        viewAllLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
