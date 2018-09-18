//
//  PollPreviewCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol PollPreviewCellDelegate {
    
    func pollPreviewCellShouldEditSession()

}

class PollPreviewCell: UICollectionViewCell {
    
    // MARK: - View vars
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var lineView: UIView!
    var dotsButton: UIButton!
    
    // MARK: - Data vars
    var delegate: PollPreviewCellDelegate!
    var index: Int!
    
    // MARK: - Constants
    let nameLabelTopPadding: CGFloat = 19.5
    let nameLabelWidth: CGFloat = 300
    let nameLabelLeftPadding: CGFloat = 17
    let codeLabelTopPadding: CGFloat = 4
    let lineViewHeight: CGFloat = 1
    let lineViewLeftPadding: CGFloat = 18
    let dotsButtonRightPadding: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK - Layout
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = ._18SemiboldFont
        contentView.addSubview(nameLabel)
    
        codeLabel = UILabel()
        codeLabel.font = ._18MediumFont
        codeLabel.textColor = .clickerGrey2
        contentView.addSubview(codeLabel)
        
        lineView = UIView()
        lineView.backgroundColor = .clickerGrey5
        contentView.addSubview(lineView)
        
        dotsButton = UIButton()
        dotsButton.setImage(#imageLiteral(resourceName: "dots"), for: .normal)
        dotsButton.addTarget(self, action: #selector(dotsBtnPressed), for: .touchUpInside)
        dotsButton.clipsToBounds = true
        contentView.addSubview(dotsButton)
    }
    
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(nameLabelTopPadding)
            make.width.equalTo(nameLabelWidth)
            make.left.equalToSuperview().offset(nameLabelLeftPadding)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(nameLabel.snp.width)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(lineViewHeight)
            make.left.equalToSuperview().offset(lineViewLeftPadding)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        dotsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(dotsButtonRightPadding)
            make.centerY.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for session: Session, delegate: PollPreviewCellDelegate) {
        nameLabel.text = session.name
        codeLabel.text = "CODE: \(session.code)"
    }
    
    // MARK: - Action
    @objc func dotsBtnPressed() {
        delegate.pollPreviewCellShouldEditSession()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
