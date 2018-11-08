//
//  PollsDateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollsDateAttendanceCell: UICollectionViewCell {

    // MARK: - View vars
    var dateLabel: UILabel!
    var checkBoxImageView: UIImageView!

    // MARK: - Constants
    let contentViewCornerRadius: CGFloat = 6
    let dateLabelLeftPadding: CGFloat = 18
    let checkBoxImageViewRightPadding: CGFloat = 18
    let checkBoxImageViewLength: CGFloat = 23
    let uncheckedImageName = "greyEmptyCircle"


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clickerGrey10
        contentView.layer.cornerRadius = contentViewCornerRadius
        contentView.clipsToBounds = true
        setupViews()
        setupConstraints()
    }

    // MARK: - Layout
    func setupViews() {
        dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.font = UIFont._16MediumFont
        contentView.addSubview(dateLabel)

        checkBoxImageView = UIImageView()
        checkBoxImageView.image = UIImage(named: uncheckedImageName)
        checkBoxImageView.contentMode = .scaleAspectFit
        contentView.addSubview(checkBoxImageView)
    }

    func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(dateLabelLeftPadding)
            make.centerY.equalToSuperview()
        }

        checkBoxImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(checkBoxImageViewRightPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(checkBoxImageViewLength)
        }
    }

    // MARK: - Configure
    func configure(for pollsDateModel: PollsDateModel) {
        dateLabel.text = reformatDateString(dateString: pollsDateModel.date)
    }

    // MARK: - Helpers
    // Converts MMM dd yyyy to MMMM d format
    func reformatDateString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringConstants.dateFormat
        let date = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
