//
//  PollMiscellaneousCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollMiscellaneousCell: UICollectionViewCell {
    
    var iconImageView: UIImageView!
    var descriptionLabel: UILabel!
    var totalVotesLabel: UILabel!
    
    // MARK: - Constants
    let iconImageViewXPadding: CGFloat = 14
    let iconImageViewLength: CGFloat = 15
    let descriptionLabelXPadding: CGFloat = 10
    let totalVotesLabelTrailingPadding: CGFloat = 14
    let endedDescriptionText = "Only you can see results"
    let sharedDescriptionText = "Shared with group"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .clickerGrey2
        descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        contentView.addSubview(descriptionLabel)
        
        totalVotesLabel = UILabel()
        totalVotesLabel.textColor = .clickerGrey2
        totalVotesLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        contentView.addSubview(totalVotesLabel)
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(iconImageViewXPadding)
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
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for miscellaneousModel: PollMiscellaneousModel) {
        switch miscellaneousModel.pollState {
        case .live:
            iconImageView.image = #imageLiteral(resourceName: "liveIcon")
        case .ended:
            iconImageView.image = #imageLiteral(resourceName: "solo_eye")
            descriptionLabel.text = endedDescriptionText
        case .shared:
            iconImageView.image = #imageLiteral(resourceName: "results_shared")
            descriptionLabel.text = sharedDescriptionText
        }
        totalVotesLabel.text = "\(miscellaneousModel.totalVotes) votes"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
