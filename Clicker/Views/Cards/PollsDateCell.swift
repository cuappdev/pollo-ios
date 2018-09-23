//
//  PollsDateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 9/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollsDateCell: UICollectionViewCell {
    
    // MARK: - View vars
    var dateLabel: UILabel!
    var numQuestionsLabel: UILabel!
    var rightArrowButtonImageView: UIImageView!
    var topSeparatorView: UIView!
    var bottomSeparatorView: UIView!
    
    // MARK: - Constants
    let dateLabelFontSize: CGFloat = 20
    let numQuestionsLabelFontSize: CGFloat = 14
    let dateLabelLeftPadding: CGFloat = 26
    let rightArrowButtonImageViewRightPadding: CGFloat = 18
    let rightArrowButtonImageViewHeight: CGFloat = 15
    let numQuestionsLabelRightPadding: CGFloat = 44
    let separatorViewHeight: CGFloat = 0.75
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
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
        
        topSeparatorView = UIView()
        topSeparatorView.backgroundColor = .clickerGrey11
        contentView.addSubview(topSeparatorView)
        
        bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = .clickerGrey11
        contentView.addSubview(bottomSeparatorView)
    }
    
    override func setNeedsUpdateConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(dateLabelLeftPadding)
            make.centerY.equalToSuperview()
        }
        
        rightArrowButtonImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(rightArrowButtonImageViewRightPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(rightArrowButtonImageViewHeight)
        }
        
        numQuestionsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(numQuestionsLabelRightPadding)
            make.centerY.equalToSuperview()
        }
        
        topSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(separatorViewHeight)
        }
        
        bottomSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(separatorViewHeight)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for pollsDateModel: PollsDateModel) {
        dateLabel.text = reformatDateString(dateString: pollsDateModel.date)
        numQuestionsLabel.text = "\(pollsDateModel.polls.count) Questions"
    }
    
    // MARK: - Helpers
    // Converts MM/dd/yy to MMMMd format
    func reformatDateString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let date = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
