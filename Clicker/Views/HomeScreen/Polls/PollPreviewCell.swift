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
    
    // MARK: - Override vars
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white
            if isSelected {
                displayOpenSessionActivityIndicatorView()
            }
        }
    }
    
    // MARK: - View vars
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var lineView: UIView!
    var dotsButton: UIButton!
    var openSessionActivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Data vars
    var delegate: PollPreviewCellDelegate!
    var index: Int!
    
    // MARK: - Constants
    let nameLabelTopPadding: CGFloat = 19.5
    let nameLabelWidth: CGFloat = 300
    let nameLabelLeftPadding: CGFloat = 17
    let activityLabelTopPadding: CGFloat = 4
    let lineViewHeight: CGFloat = 1
    let lineViewLeftPadding: CGFloat = 18
    let dotsButtonRightPadding: CGFloat = 12
    let dotsButtonLength: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK - Layout
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = ._18SemiboldFont
        contentView.addSubview(nameLabel)
    
        descriptionLabel = UILabel()
        descriptionLabel.font = ._16MediumFont
        descriptionLabel.textColor = .clickerGrey2
        contentView.addSubview(descriptionLabel)
        
        lineView = UIView()
        lineView.backgroundColor = .clickerGrey5
        contentView.addSubview(lineView)
        
        dotsButton = UIButton()
        dotsButton.setImage(#imageLiteral(resourceName: "dots"), for: .normal)
        dotsButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
        dotsButton.addTarget(self, action: #selector(dotsBtnPressed), for: .touchUpInside)
        dotsButton.clipsToBounds = true
        contentView.addSubview(dotsButton)
        
        openSessionActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        openSessionActivityIndicatorView.isHidden = true
        openSessionActivityIndicatorView.isUserInteractionEnabled = false
        contentView.addSubview(openSessionActivityIndicatorView)
    }
    
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(nameLabelTopPadding)
            make.width.equalTo(nameLabelWidth)
            make.left.equalToSuperview().offset(nameLabelLeftPadding)
        }
        
        descriptionLabel.snp.makeConstraints { make in
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
            make.width.height.equalTo(dotsButtonLength)
        }
        openSessionActivityIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(dotsButton.snp.top)
            make.width.equalTo(dotsButton.snp.width)
            make.height.equalTo(dotsButton.snp.height)
            make.trailing.equalTo(dotsButton.snp.trailing)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for session: Session, delegate: PollPreviewCellDelegate) {
        self.delegate = delegate
        nameLabel.text = session.name
        if let isLive = session.isLive, isLive {
            descriptionLabel.text = "LIVE"
        } else {
            descriptionLabel.text = session.description
        }
    }
    
    // MARK: - Action
    @objc func dotsBtnPressed() {
        delegate.pollPreviewCellShouldEditSession()
    }
    
    // MARK: - Activity Indicator
    func displayOpenSessionActivityIndicatorView() {
        dotsButton.isHidden = true
        dotsButton.isUserInteractionEnabled = false
        
        openSessionActivityIndicatorView.isHidden = false
        openSessionActivityIndicatorView.isUserInteractionEnabled = true
        openSessionActivityIndicatorView.startAnimating()
    }
    
    func hideOpenSessionActivityIndicatorView() {
        openSessionActivityIndicatorView.stopAnimating()
        openSessionActivityIndicatorView.isHidden = true
        openSessionActivityIndicatorView.isUserInteractionEnabled = false
        
        dotsButton.isHidden = false
        dotsButton.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
