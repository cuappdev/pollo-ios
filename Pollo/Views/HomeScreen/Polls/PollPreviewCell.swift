//
//  PollPreviewCell.swift
//  Pollo
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol PollPreviewCellDelegate: class {

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
    var descriptionLabel: UILabel!
    var dotsButton: UIButton!
    var lineView: UIView!
    var liveCircleView: UIView!
    var liveLabel: UILabel!
    var nameLabel: UILabel!
    var openSessionActivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Data vars
    var index: Int!
    weak var delegate: PollPreviewCellDelegate?
    
    // MARK: - Constants
    let activityLabelTopPadding: CGFloat = 4
    let dotsButtonImageName = "threedots"
    let dotsButtonLength: CGFloat = 52
    let dotsButtonRightPadding: CGFloat = 18.0
    let liveCircleViewLength: CGFloat = 7
    let liveCircleViewTopPadding: CGFloat = 8.0
    let liveLabelLeftPadding: CGFloat = 6.0
    let lineViewHeight: CGFloat = 1
    let lineViewLeftPadding: CGFloat = 18
    let liveLabelText = "Live Now"
    let nameLabelLeftPadding: CGFloat = 18.0
    let nameLabelTopPadding: CGFloat = 20.0
    let nameLabelWidth: CGFloat = 300
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = ._18SemiboldFont
        contentView.addSubview(nameLabel)
    
        descriptionLabel = UILabel()
        descriptionLabel.font = ._16SemiboldFont
        descriptionLabel.textColor = .blueGrey
        contentView.addSubview(descriptionLabel)
        
        liveCircleView = UIView()
        liveCircleView.backgroundColor = .polloGreen
        liveCircleView.layer.cornerRadius = liveCircleViewLength / 2.0
        liveCircleView.isHidden = true
        contentView.addSubview(liveCircleView)
        
        liveLabel = UILabel()
        liveLabel.text = liveLabelText
        liveLabel.font = ._16SemiboldFont
        liveLabel.textColor = .polloGreen
        liveLabel.isHidden = true
        contentView.addSubview(liveLabel)
        
        lineView = UIView()
        lineView.backgroundColor = .clickerGrey5
        contentView.addSubview(lineView)
        
        dotsButton = UIButton()
        dotsButton.setImage(#imageLiteral(resourceName: dotsButtonImageName), for: .normal)
        dotsButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
        dotsButton.addTarget(self, action: #selector(dotsBtnPressed), for: .touchUpInside)
        dotsButton.clipsToBounds = true
        contentView.addSubview(dotsButton)
        
        openSessionActivityIndicatorView = UIActivityIndicatorView(style: .gray)
        openSessionActivityIndicatorView.isHidden = true
        openSessionActivityIndicatorView.isUserInteractionEnabled = false
        contentView.addSubview(openSessionActivityIndicatorView)
    }
    
    override func updateConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(nameLabelTopPadding)
            make.width.equalTo(nameLabelWidth)
            make.leading.equalToSuperview().offset(nameLabelLeftPadding)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.equalTo(nameLabel.snp.width)
        }
        
        liveCircleView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(liveCircleViewTopPadding)
            make.width.height.equalTo(liveCircleViewLength)
        }
        
        liveLabel.snp.makeConstraints { make in
            make.leading.equalTo(liveCircleView.snp.trailing).offset(liveLabelLeftPadding)
            make.centerY.equalTo(liveCircleView.snp.centerY)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(lineViewHeight)
            make.leading.equalToSuperview().offset(lineViewLeftPadding)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        dotsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(dotsButtonRightPadding)
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
        descriptionLabel.text = session.description
        let isLive = session.isLive ?? false
        descriptionLabel.isHidden = isLive
        liveCircleView.isHidden = !isLive
        liveLabel.isHidden = !isLive
    }
    
    // MARK: - Action
    @objc func dotsBtnPressed() {
        delegate?.pollPreviewCellShouldEditSession()
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
