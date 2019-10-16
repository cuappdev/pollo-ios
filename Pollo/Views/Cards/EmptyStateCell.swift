//
//  EmptyStateCell.swift
//  Pollo
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol EmptyStateCellDelegate: class {
    func emptyStateCellDidTapCreateDraftButton()
}

class EmptyStateCell: UICollectionViewCell {
    
    // MARK: View vars
    var containerView: UIView!
    var createDraftButton: UIButton!
    var iconImageView: UIImageView!
    var nameView: NameView!
    var subtitleLabel: UILabel!
    var titleLabel: UILabel!
    
    // MARK: - Data vars
    var emptyStateModel: EmptyStateModel!
    weak var delegate: EmptyStateCellDelegate?

    // MARK: - Constants
    let adminNothingToSeeText = "Nothing to see here."
    let adminWaitingText = "You haven’t made any polls yet!\nTap \"+\" above to try it out."
    let cardControllerIconImageViewLength: CGFloat = 50.0
    let countLabelWidth: CGFloat = 42.0
    let createDraftButtonHeight: CGFloat = 47
    let createDraftButtonText = "Create a draft"
    let createDraftButtonTopPadding: CGFloat = 15.0
    let createDraftButtonWidth: CGFloat = 169.5
    let createNewGroupText = "Tap \"+\" above to create a new group!"
    let createdString = "created"
    let draftsViewControllerIconImageViewLength: CGFloat = 50.0
    let draftsViewControllerIconImageViewTopPadding: CGFloat = 200.0
    let enterCodeText = "Enter a code below to join a group!"
    let iconImageViewTopPadding: CGFloat = 176.0
    let joinedString = "joined"
    let manShruggingImageName = "man_shrugging"
    let monkeyEmojiImageName = "monkey_emoji"
    let noDraftsText = "No saved drafts!"
    let pollsViewControllerIconImageViewTopPadding: CGFloat = 88.0
    let pollsViewControllerIconImageViewLength: CGFloat = 50.0
    let subtitleLabelTopPadding: CGFloat = 8.0
    let subtitleLabelWidth: CGFloat = 250.0
    let titleLabelTopPadding: CGFloat = 16.0
    let titleLabelWidth: CGFloat = 200.0
    let topPadding: CGFloat = 20
    let userNothingToSeeText = "Nothing to see yet."
    let userWaitingText = "Waiting for the host to post a poll..."
    let womanShruggingImageName = "woman_shrugging"
    let zoomInScale: CGFloat = 0.85
    let zoomTimeInterval: TimeInterval = 0.35

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
        containerView = UIView()
        contentView.addSubview(containerView)

        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
        
        titleLabel = UILabel()
        titleLabel.font = ._18SemiboldFont
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = ._14MediumFont
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.numberOfLines = 0
        containerView.addSubview(subtitleLabel)
        
        createDraftButton = UIButton()
        createDraftButton.clipsToBounds = true
        createDraftButton.layer.cornerRadius = createDraftButtonHeight / 2
        createDraftButton.setTitle(createDraftButtonText, for: .normal)
        createDraftButton.setTitleColor(.white, for: .normal)
        createDraftButton.addTarget(self, action: #selector(createDraftButtonPressed), for: .touchUpInside)
        createDraftButton.addTarget(self, action: #selector(zoomIn), for: .touchDown)
        createDraftButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        createDraftButton.addTarget(self, action: #selector(zoomOut), for: .touchUpOutside)
        createDraftButton.layer.borderColor = UIColor.white.cgColor
        createDraftButton.layer.borderWidth = 1
        createDraftButton.backgroundColor = .clear
        containerView.addSubview(createDraftButton)
    }
    
    @objc func zoomIn(sender: UIButton) {
        UIView.animate(withDuration: zoomTimeInterval) {
            sender.transform = CGAffineTransform(scaleX: self.zoomInScale, y: self.zoomInScale)
        }
    }
    
    @objc func zoomOut(sender: UIButton) {
        UIView.animate(withDuration: zoomTimeInterval) {
            sender.transform = .identity
        }
    }
    
    @objc func createDraftButtonPressed() {
        delegate?.emptyStateCellDidTapCreateDraftButton()
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            switch emptyStateModel.type {
            case .pollsViewController:
                make.width.height.equalTo(pollsViewControllerIconImageViewLength)
                make.top.equalToSuperview()
            case .cardController:
                make.width.height.equalTo(cardControllerIconImageViewLength)
                make.top.equalToSuperview()
            }
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(titleLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(titleLabelTopPadding)
        }
        
        switch emptyStateModel.type {
        case .pollsViewController:
            subtitleLabel.snp.makeConstraints { make in
                make.width.equalTo(subtitleLabelWidth)
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(subtitleLabelTopPadding)
            }
            containerView.snp.makeConstraints { make in
                make.leading.trailing.centerY.equalToSuperview()
                make.top.equalTo(iconImageView)
                make.bottom.equalTo(subtitleLabel)
            }
        case .cardController:
            subtitleLabel.snp.makeConstraints { make in
                make.width.equalTo(subtitleLabelWidth)
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(subtitleLabelTopPadding)
            }
            containerView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalToSuperview().offset(-topPadding)
                make.top.equalTo(iconImageView)
                make.bottom.equalTo(subtitleLabel)
            }
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for emptyStateModel: EmptyStateModel, session: Session?, shouldDisplayNameView: Bool?, nameViewDelegate: NameViewDelegate?) {
        self.emptyStateModel = emptyStateModel
        subtitleLabel.textColor = .blueyGrey
        switch emptyStateModel.type {
        case .pollsViewController(let pollType):
            switch pollType {
            case .created:
                iconImageView.image = UIImage(named: manShruggingImageName)
                titleLabel.text = "No groups \(createdString)"
                subtitleLabel.text = createNewGroupText
            case .joined:
                iconImageView.image = UIImage(named: womanShruggingImageName)
                titleLabel.text = "No groups \(joinedString)"
                subtitleLabel.text = enterCodeText
            }
            
            titleLabel.textColor = .black
        case .cardController(let userRole):
            iconImageView.image = UIImage(named: monkeyEmojiImageName)
            titleLabel.textColor = .clickerGrey5
            titleLabel.text = userRole == .admin ? adminNothingToSeeText : userNothingToSeeText
            if let session = session, let shouldDisplayNameView = shouldDisplayNameView, let nameViewDelegate = nameViewDelegate, shouldDisplayNameView {
                setupNameView(with: session, nameViewDelegate: nameViewDelegate)
            }
            subtitleLabel.text = userRole == .admin ? adminWaitingText : userWaitingText
        }
    }

    // MARK: - NAME THE POLL
    func setupNameView(with session: Session, nameViewDelegate: NameViewDelegate) {
        nameView = NameView(frame: .zero, session: session, delegate: nameViewDelegate)
        contentView.addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
