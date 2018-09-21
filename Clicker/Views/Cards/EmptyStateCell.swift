//
//  EmptyStateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class EmptyStateCell: UICollectionViewCell {
    
    //MARK: View vars
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var nameView: NameView!
    
    // MARK: - Data vars
    var emptyStateModel: EmptyStateModel!

    // MARK: - Constants
    let pollsViewControllerIconImageViewLength: CGFloat = 45.0
    let cardControllerIconImageViewLength: CGFloat = 32.0
    let iconImageViewTopPadding: CGFloat = 142.0
    let titleLabelWidth: CGFloat = 200.0
    let titleLabelTopPadding: CGFloat = 18.5
    let subtitleLabelWidth: CGFloat = 220.0
    let subtitleLabelTopPadding: CGFloat = 7.5
    let countLabelWidth: CGFloat = 42.0
    let createNewQuestionText = "Create a new question above!"
    let enterCodeText = "Enter a code below to join!"
    let adminNothingToSeeText = "Nothing to see here."
    let userNothingToSeeText = "Nothing to see yet."
    let adminWaitingText = "You haven't asked any polls yet!\nTry it out below."
    let userWaitingText = "Waiting for the host to post a poll."

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupViews()
    }
    
    func setupViews() {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        titleLabel = UILabel()
        titleLabel.font = ._16SemiboldFont
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = ._14MediumFont
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            switch emptyStateModel.type {
            case .pollsViewController(_):
                make.width.height.equalTo(pollsViewControllerIconImageViewLength)
            case .cardController(_):
                make.width.height.equalTo(cardControllerIconImageViewLength)
            }
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(iconImageViewTopPadding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(titleLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(titleLabelTopPadding)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.width.equalTo(subtitleLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(subtitleLabelTopPadding)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for emptyStateModel: EmptyStateModel, session: Session?, shouldDisplayNameView: Bool?, nameViewDelegate: NameViewDelegate?) {
        self.emptyStateModel = emptyStateModel
        switch emptyStateModel.type {
        case .pollsViewController(let pollType):
            iconImageView.image = #imageLiteral(resourceName: "shrug_emoji")
            titleLabel.textColor = .black
            let pollTypeString = pollType == .created ? "created" : "joined"
            titleLabel.text = "No polls \(pollTypeString)"
            subtitleLabel.text = pollType == .created ? createNewQuestionText : enterCodeText
        case .cardController(let userRole):
            if let session = session, let shouldDisplayNameView = shouldDisplayNameView, let nameViewDelegate = nameViewDelegate, shouldDisplayNameView {
                setupNameView(with: session, nameViewDelegate: nameViewDelegate)
            }
            iconImageView.image = #imageLiteral(resourceName: "monkey_emoji")
            titleLabel.textColor = .clickerGrey5
            titleLabel.text = userRole == .admin ? adminNothingToSeeText : userNothingToSeeText
            subtitleLabel.text = userRole == .admin ? adminWaitingText : userWaitingText
        }
        subtitleLabel.textColor = .clickerGrey2
    }
    
    // MARK - NAME THE POLL
    func setupNameView(with session: Session, nameViewDelegate: NameViewDelegate) {
        nameView = NameView(frame: .zero, session: session, delegate: nameViewDelegate)
        contentView.addSubview(nameView)
        
        nameView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
