//
//  AddMoreOptionCell.swift
//  Pollo
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class AddMoreOptionCell: UICollectionViewCell {
    
    // MARK: Views
    var addMoreLabel: UILabel!
    var plusLabel: UILabel!
    var wholeButton: UIButton!
    
    // MARK: Data
    weak var delegate: PollBuilderMCOptionSectionControllerDelegate?

    // MARK: - Constants
    let addMoreLabelLeftPadding: CGFloat = 6.5
    let bottomPadding: CGFloat = 6
    let edgePadding: CGFloat = 18
    let plusLabelWidth: CGFloat = 13
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.clickerGrey5.cgColor
        setupViews()
        setupConstraints()
    }
    
    func configure(with delegate: PollBuilderMCOptionSectionControllerDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        wholeButton = UIButton()
        wholeButton.frame = contentView.frame
        wholeButton.backgroundColor = .white
        wholeButton.layer.cornerRadius = contentView.layer.cornerRadius
        wholeButton.layer.shadowColor = UIColor.clickerWhite2.cgColor
        wholeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        wholeButton.layer.shadowOpacity = 1.0
        wholeButton.layer.shadowRadius = 2.5
        wholeButton.layer.masksToBounds = false
        wholeButton.addTarget(self, action: #selector(didPressCell), for: .touchUpInside)
        contentView.addSubview(wholeButton)
        
        plusLabel = UILabel()
        plusLabel.text = "+"
        plusLabel.textColor = .blueGrey
        plusLabel.textAlignment = .center
        plusLabel.font = ._20BoldFont
        contentView.addSubview(plusLabel)
        
        addMoreLabel = UILabel()
        addMoreLabel.text = "Add Option"
        addMoreLabel.textColor = .blueGrey
        addMoreLabel.font = ._16RegularFont
        contentView.addSubview(addMoreLabel)
    }

    func setupConstraints() {
        plusLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(edgePadding)
            make.width.equalTo(plusLabelWidth)
            make.centerY.equalToSuperview()
        }
        
        addMoreLabel.snp.updateConstraints { make in
            make.leading.equalTo(plusLabel.snp.trailing).offset(addMoreLabelLeftPadding)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func didPressCell() {
        delegate?.pollBuilderSectionControllerShouldAddOption()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
