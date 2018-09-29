//
//  EmptyStateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol EmptyStateCellDelegate {
    func emptyStateCellDidTapCreateDraftButton()
}

class EmptyStateCell: UICollectionViewCell {
    
    //MARK: View vars
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var nameView: NameView!
    var createDraftButton: UIButton!
    
    // MARK: - Data vars
    var emptyStateModel: EmptyStateModel!
    var delegate: EmptyStateCellDelegate!

    // MARK: - Constants
    let pollsViewControllerIconImageViewLength: CGFloat = 45.0
    let cardControllerIconImageViewLength: CGFloat = 32.0
    let draftsViewControllerIconImageViewLength: CGFloat = 50.0
    let iconImageViewTopPadding: CGFloat = 142.0
    let draftsViewControllerIconImageViewTopPadding: CGFloat = 200.0
    let titleLabelWidth: CGFloat = 200.0
    let titleLabelTopPadding: CGFloat = 18.5
    let subtitleLabelWidth: CGFloat = 220.0
    let createDraftButtonTopPadding: CGFloat = 15.0
    let subtitleLabelTopPadding: CGFloat = 7.5
    let countLabelWidth: CGFloat = 42.0
    let createDraftButtonWidth: CGFloat = 169.5
    let createDraftButtonHeight: CGFloat = 47
    let zoomTimeInterval: TimeInterval = 0.35
    let zoomInScale: CGFloat = 0.85
    let createNewGroupText = "Create a new group above!"
    let enterCodeText = "Enter a code below to join!"
    let adminNothingToSeeText = "Nothing to see here."
    let userNothingToSeeText = "Nothing to see yet."
    let adminWaitingText = "You haven't asked any polls yet!\nTry it out below."
    let userWaitingText = "Waiting for the host to post a poll."
    let noDraftsText = "No saved drafts!"
    let createDraftButtonText = "Create a draft"
    let createdString = "created"
    let joinedString = "joined"
    let manShruggingImageName = "man_shrugging"
    let monkeyEmojiImageName = "monkey_emoji"
    let womanShruggingImageName = "woman_shrugging"

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
        contentView.addSubview(createDraftButton)
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
        delegate.emptyStateCellDidTapCreateDraftButton()
    }
    
    override func updateConstraints() {
        iconImageView.snp.makeConstraints { make in
            switch emptyStateModel.type {
            case .pollsViewController(_):
                make.width.height.equalTo(pollsViewControllerIconImageViewLength)
                make.top.equalToSuperview().offset(iconImageViewTopPadding)
                break
            case .cardController(_):
                make.width.height.equalTo(cardControllerIconImageViewLength)
                make.top.equalToSuperview().offset(iconImageViewTopPadding)
                break
            case .draftsViewController(_):
                make.width.height.equalTo(draftsViewControllerIconImageViewLength)
                make.top.equalToSuperview().offset(draftsViewControllerIconImageViewTopPadding)
            }
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(titleLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(titleLabelTopPadding)
        }
        
        switch emptyStateModel.type {
        case .pollsViewController(_):
            subtitleLabel.snp.makeConstraints { make in
                make.width.equalTo(subtitleLabelWidth)
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(subtitleLabelTopPadding)
            }
            break
        case .cardController(_):
            subtitleLabel.snp.makeConstraints { make in
                make.width.equalTo(subtitleLabelWidth)
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(subtitleLabelTopPadding)
            }
            break
        case .draftsViewController(_):
            createDraftButton.snp.makeConstraints { make in
                make.width.equalTo(createDraftButtonWidth)
                make.height.equalTo(createDraftButtonHeight)
                make.top.equalTo(titleLabel.snp.bottom).offset(createDraftButtonTopPadding)
                make.centerX.equalToSuperview()
            }
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for emptyStateModel: EmptyStateModel, session: Session?, shouldDisplayNameView: Bool?, nameViewDelegate: NameViewDelegate?) {
        self.emptyStateModel = emptyStateModel
        switch emptyStateModel.type {
        case .pollsViewController(let pollType):
            iconImageView.image = UIImage(named: manShruggingImageName)
            titleLabel.textColor = .black
            let pollTypeString = pollType == .created ? createdString : joinedString
            titleLabel.text = "No groups \(pollTypeString)"
            subtitleLabel.text = pollType == .created ? createNewGroupText : enterCodeText
            break
        case .cardController(let userRole):
            if let session = session, let shouldDisplayNameView = shouldDisplayNameView, let nameViewDelegate = nameViewDelegate, shouldDisplayNameView {
                setupNameView(with: session, nameViewDelegate: nameViewDelegate)
            }
            iconImageView.image = UIImage(named: monkeyEmojiImageName)
            titleLabel.textColor = .clickerGrey5
            titleLabel.text = userRole == .admin ? adminNothingToSeeText : userNothingToSeeText
            subtitleLabel.text = userRole == .admin ? adminWaitingText : userWaitingText
            break
        case .draftsViewController(let delegate):
            iconImageView.image = UIImage(named: womanShruggingImageName)
            titleLabel.textColor = .white
            titleLabel.text = noDraftsText
            self.delegate = delegate
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
