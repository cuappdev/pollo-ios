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
    var numQuestionsLabel: UILabel!
    var rightArrowButtonImageView: UIImageView!
    
    // MARK: - Constants
    let cellCornerRadius: CGFloat = 5
    let dateLabelFontSize: CGFloat = 16
    let dateLabelLeftPadding: CGFloat = 16
    let greyViewInset: CGFloat = 16
    let numQuestionsLabelFontSize: CGFloat = 11
    let numQuestionsLabelRightPadding: CGFloat = 40.5
    let rightArrowButtonImageViewHeight: CGFloat = 15
    let rightArrowButtonImageViewRightPadding: CGFloat = 13
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkestGray
        
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        greyView = UIView()
        greyView.backgroundColor = .darkgray
        greyView.layer.cornerRadius = cellCornerRadius
        contentView.addSubview(greyView)

        dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.font = UIFont.boldSystemFont(ofSize: dateLabelFontSize)
        contentView.addSubview(dateLabel)
        
        numQuestionsLabel = UILabel()
        numQuestionsLabel.textColor = .white
        numQuestionsLabel.font = UIFont.systemFont(ofSize: numQuestionsLabelFontSize)
        numQuestionsLabel.textAlignment = .right
        contentView.addSubview(numQuestionsLabel)
        
        rightArrowButtonImageView = UIImageView()
        rightArrowButtonImageView.image = #imageLiteral(resourceName: "forward_arrow")
        rightArrowButtonImageView.contentMode = .scaleAspectFit
        contentView.addSubview(rightArrowButtonImageView)
    
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
        
        numQuestionsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(greyView.snp.trailing).inset(numQuestionsLabelRightPadding)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for pollsDateModel: PollsDateModel) {
        dateLabel.text = reformatDate(pollsDateModel.dateValue)
        let numPolls = pollsDateModel.polls.count
        numQuestionsLabel.text = "\(numPolls) \(numPolls > 1 ? "Questions" : "Question")"
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
