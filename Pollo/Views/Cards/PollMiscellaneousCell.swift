//
//  PollMiscellaneousCell.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollMiscellaneousCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var userRole: UserRole!
    
    // MARK: - View vars
    var descriptionLabel: UILabel!
    var iconImageView: UIImageView!
    var totalVotesLabel: UILabel!
    
    // MARK: - Constants
    let descriptionLabelXPadding: CGFloat = 10
    let endedTextMember = "Poll Closed"
    let iconImageViewLength: CGFloat = 15
    let labelFontSize: CGFloat = 12
    let liveEndedDescriptionTextAdmin = "Only you can see results"
    let liveOpenTextMember = "Open for responses"
    let liveSubmittedTextMember = "Submitted! Tap other answers to change"
    let responseString = "response"
    let sharedDescriptionText = "Shared with group"
    let sharedTextMember = "Final results  • "
    let totalVotesLabelTrailingPadding: CGFloat = 18
    let voteString = "Vote"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .offWhite
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .blueyGrey
        descriptionLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        contentView.addSubview(descriptionLabel)
        
        totalVotesLabel = UILabel()
        totalVotesLabel.textColor = .blueyGrey
        totalVotesLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        contentView.addSubview(totalVotesLabel)
    }
    
    override func updateConstraints() {
        
        switch userRole! {
        case .admin:
            iconImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(LayoutConstants.cardHorizontalPadding)
                make.width.height.equalTo(iconImageViewLength)
                make.centerY.equalToSuperview()
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(descriptionLabelXPadding)
                make.centerY.equalToSuperview()
            }
            
            totalVotesLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(totalVotesLabelTrailingPadding)
                make.centerY.equalToSuperview()
            }
        case .member:
            
            descriptionLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for miscellaneousModel: PollMiscellaneousModel) {
        self.userRole = miscellaneousModel.userRole
        switch miscellaneousModel.userRole {
        case .admin:
            descriptionLabel.textAlignment = .left
            switch miscellaneousModel.pollState {
            case .live, .ended:
                iconImageView.image = #imageLiteral(resourceName: "solo_eye")
                descriptionLabel.text = "Only you can see results"
            case .shared:
                iconImageView.image = #imageLiteral(resourceName: "results_shared")
                descriptionLabel.text = "Shared with group"
            }
            var unit: String
            switch miscellaneousModel.questionType! {
            case .multipleChoice:
                unit = miscellaneousModel.totalVotes == 1 ? voteString : "\(voteString)s"
            }
            totalVotesLabel.text = "\(miscellaneousModel.totalVotes) \(unit)"
        case .member:
            descriptionLabel.textAlignment = .center
            switch miscellaneousModel.pollState {
            case .live:
                descriptionLabel.text = miscellaneousModel.didSubmitChoice ? liveSubmittedTextMember : liveOpenTextMember
            case .ended:
                descriptionLabel.text = endedTextMember
            case .shared:
                var unit: String
                switch miscellaneousModel.questionType! {
                case .multipleChoice:
                    unit = miscellaneousModel.totalVotes == 1 ? voteString : "\(voteString)s"
                }
                descriptionLabel.text = "\(sharedTextMember) \(miscellaneousModel.totalVotes) \(unit)"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
