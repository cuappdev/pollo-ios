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
    var totalResponsesLabel: UILabel!
    
    // MARK: - Constants
    let descriptionLabelXPadding: CGFloat = 10
    let endedTextMember = "Poll Closed"
    let iconImageViewLength: CGFloat = 15
    let labelFontSize: CGFloat = 12
    let liveEndedDescriptionTextAdmin = "Only you can see results"
    let liveOpenTextMember = "Open for responses"
    let liveSubmittedTextMember = "Submitted! Tap other answers to change"
    let responseString = "Response"
    let sharedDescriptionText = "Shared with group"
    let sharedTextMember = "Final results  • "
    let totalResponsesLabelTrailingPadding: CGFloat = 18
    
    
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
        descriptionLabel.textColor = .blueGrey
        descriptionLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        contentView.addSubview(descriptionLabel)
        
        totalResponsesLabel = UILabel()
        totalResponsesLabel.textColor = .blueGrey
        totalResponsesLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        contentView.addSubview(totalResponsesLabel)
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
            
            totalResponsesLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(totalResponsesLabelTrailingPadding)
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
                descriptionLabel.text = liveEndedDescriptionTextAdmin
            case .shared:
                iconImageView.image = #imageLiteral(resourceName: "results_shared")
                descriptionLabel.text = sharedDescriptionText
            }
            var unit: String
            switch miscellaneousModel.questionType! {
            case .multipleChoice:
                unit = miscellaneousModel.totalResponses == 1 ? responseString : "\(responseString)s"
            }
            totalResponsesLabel.text = "\(miscellaneousModel.totalResponses) \(unit)"
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
                    unit = miscellaneousModel.totalResponses == 1 ? responseString : "\(responseString)s"
                }
                descriptionLabel.text = "\(sharedTextMember) \(miscellaneousModel.totalResponses) \(unit)"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
