//
//  GroupControlsInfoView.swift
//  Clicker
//
//  Created by Kevin Chan on 11/10/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupControlsInfoView: UIView {

    // MARK: - View vars
    var numMembersLabel: UILabel!
    var numPollsLabel: UILabel!
    var codeLabel: UILabel!
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
        numMembersLabel.font = ._16MediumFont
        numMembersLabel.textAlignment = .center
        addSubview(numMembersLabel)

        numPollsLabel = UILabel()
        numPollsLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        numPollsLabel.font = ._16MediumFont
        numPollsLabel.textAlignment = .center
        addSubview(numPollsLabel)

        codeLabel = UILabel()
        codeLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        codeLabel.font = ._16MediumFont
        codeLabel.textAlignment = .center
        addSubview(codeLabel)

        separatorLineView1 = UIView()
        separatorLineView1.backgroundColor = .clickerGrey14
        addSubview(separatorLineView1)

        separatorLineView2 = UIView()
        separatorLineView2.backgroundColor = .clickerGrey14
        addSubview(separatorLineView2)
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
    
    // MARK: - Configure
    func configure(numMembers: Int, numPolls: Int, code: String) {
        numMembersLabel.text = "\(numMembers) members"
        numPollsLabel.text = "\(numPolls) polls"
        codeLabel.text = "Code: \(code)"
    }

}
