//
//  DraftsTitleCell.swift
//  Pollo
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class DraftsTitleCell: UICollectionViewCell {

    // MARK: - View vars
    var draftsLabel: UILabel!
    
    // MARK: - Constraints
    let draftsLabelBottomInset = 14

    override init(frame: CGRect) {
        super.init(frame: frame)

        draftsLabel = UILabel()
        draftsLabel.font = ._18SemiboldFont
        draftsLabel.textAlignment = .center
        contentView.addSubview(draftsLabel)

        draftsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(draftsLabelBottomInset)
        }
    }

    // MARK: - Configure
    func configure(with draftsTitleModel: DraftsTitleModel) {
        draftsLabel.text = "Drafts(\(draftsTitleModel.numDrafts))"
    }

    func shouldLightenText(_ shouldLighten: Bool) {
        let textColor: UIColor = shouldLighten ? .clickerGrey2 : .black
        draftsLabel.textColor = textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
