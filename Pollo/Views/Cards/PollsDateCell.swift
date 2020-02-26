//
//  PollsDateCell.swift
//  Pollo
//
//  Created by Kevin Chan on 9/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollsDateCell: UICollectionViewCell {
    
    // MARK: - View vars
    var dateLabel: UILabel!
    var greyView: UIView!
    var rightArrowButtonImageView: UIImageView!
    var indicatorDot: UIView!
    
    // MARK: - Constants
    let cellCornerRadius: CGFloat = 5
    let dateLabelFontSize: CGFloat = 16
    let dateLabelLeftPadding: CGFloat = 25
    let greyViewInset: CGFloat = 16
    let rightArrowButtonImageViewHeight: CGFloat = 15
    let rightArrowButtonImageViewRightPadding: CGFloat = 13
    let indicatorDotLeftPadding: CGFloat = 10
    let indicatorDotHeight: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkestGrey
        
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        greyView = UIView()
        greyView.backgroundColor = .darkGrey
        greyView.layer.cornerRadius = cellCornerRadius
        contentView.addSubview(greyView)

        dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.font = UIFont.boldSystemFont(ofSize: dateLabelFontSize)
        contentView.addSubview(dateLabel)
        
        rightArrowButtonImageView = UIImageView()
        rightArrowButtonImageView.image = #imageLiteral(resourceName: "forward_arrow")
        rightArrowButtonImageView.contentMode = .scaleAspectFit
        contentView.addSubview(rightArrowButtonImageView)

        indicatorDot = UIView()
        indicatorDot.backgroundColor = .polloGreen
        indicatorDot.layer.cornerRadius = indicatorDotHeight / 2
        contentView.addSubview(indicatorDot)
    
    }
    
    override func setNeedsUpdateConstraints() {
        greyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(greyViewInset)
            make.top.bottom.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(greyView.snp.leading).offset(dateLabelLeftPadding)
            make.centerY.equalToSuperview()
        }
        
        rightArrowButtonImageView.snp.makeConstraints { make in
            make.trailing.equalTo(greyView.snp.trailing).inset(rightArrowButtonImageViewRightPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(rightArrowButtonImageViewHeight)
        }

        indicatorDot.snp.makeConstraints { make in
            make.leading.equalTo(greyView.snp.leading).offset(indicatorDotLeftPadding)
            make.centerY.equalTo(greyView)
            make.height.width.equalTo(indicatorDotHeight)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for pollsDateModel: PollsDateModel) {
        dateLabel.text = reformatDate(pollsDateModel.dateValue)
        indicatorDot.isHidden = !pollsDateModel.polls.contains(where: { $0.state == .live })
    }
    
    // MARK: - Helpers
    // Converts Unix timestamp to MMMM d format
    func reformatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date.toLocalTime())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
