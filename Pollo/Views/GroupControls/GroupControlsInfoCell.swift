//
//  InfoViewCell.swift
//  Pollo
//
//  Created by Mathew Scullin on 3/10/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class GroupControlsInfoCell: UICollectionViewCell {
    
    // MARK: - View vars
    var codeLabel: UILabel!
    var numMembersLabel: UILabel!
    var numPollsLabel: UILabel!
    var separatorLineView1: UIView!
    var separatorLineView2: UIView!
    
    // MARK: - Constants
    let horizontalPadding: CGFloat = 15
    let separatorLineWidth: CGFloat = 1.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        numMembersLabel = UILabel()
        numMembersLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        numMembersLabel.font = ._16SemiboldFont
        numMembersLabel.textAlignment = .center
        contentView.addSubview(numMembersLabel)
        
        numPollsLabel = UILabel()
        numPollsLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        numPollsLabel.font = ._16SemiboldFont
        numPollsLabel.textAlignment = .center
        contentView.addSubview(numPollsLabel)
        
        codeLabel = UILabel()
        codeLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        codeLabel.font = ._16SemiboldFont
        codeLabel.textAlignment = .center
        contentView.addSubview(codeLabel)
        
        separatorLineView1 = UIView()
        separatorLineView1.backgroundColor = .clickerGrey14
        contentView.addSubview(separatorLineView1)
        
        separatorLineView2 = UIView()
        separatorLineView2.backgroundColor = .clickerGrey14
        contentView.addSubview(separatorLineView2)
    }
    
    private func setupConstraints() {
        numPollsLabel.snp.makeConstraints { make in
            make.center.height.equalToSuperview()
        }
        
        separatorLineView1.snp.makeConstraints { make in
            make.trailing.equalTo(numPollsLabel.snp.leading).offset(-horizontalPadding)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(separatorLineWidth)
        }
        
        numMembersLabel.snp.makeConstraints { make in
            make.trailing.equalTo(separatorLineView1.snp.leading).offset(-horizontalPadding)
            make.height.centerY.equalToSuperview()
        }
        
        separatorLineView2.snp.makeConstraints { make in
            make.leading.equalTo(numPollsLabel.snp.trailing).offset(horizontalPadding)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(separatorLineWidth)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLineView2.snp.trailing).offset(horizontalPadding)
            make.height.centerY.equalToSuperview()
        }
    }
    
    func configure(for information: GroupControlsInfoModel) {
        let memberDescriptor = information.numMembers == 1 ? "member" : "members"
        let pollsDescriptor = information.numPolls == 1 ? "poll" : "polls"
        numMembersLabel.text = "\(information.numMembers) \(memberDescriptor)"
        numPollsLabel.text = "\(information.numPolls) \(pollsDescriptor)"
        codeLabel.text = "Code: \(information.code)"
    }
}
