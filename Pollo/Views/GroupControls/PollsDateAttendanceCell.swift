//
//  PollsDateCell.swift
//  Pollo
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollsDateAttendanceCell: UICollectionViewCell {

    // MARK: - View vars
    var checkBoxImageView: UIImageView!
    var containerView: UIView!
    var dateLabel: UILabel!

    // MARK: - Data vars
    var checkedImage: UIImage!
    var uncheckedImage: UIImage!

    // MARK: - Constants
    let checkBoxImageViewLength: CGFloat = 23
    let checkBoxImageViewRightPadding: CGFloat = 18
    let checkedImageName = "option_filled"
    let containerViewHeight: CGFloat = 47
    let contentViewCornerRadius: CGFloat = 6
    let dateLabelLeftPadding: CGFloat = 18
    let uncheckedImageName = "greyEmptyCircle"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    // MARK: - Layout
    func setupViews() {
        containerView = UIView()
        containerView.backgroundColor = .darkgray
        containerView.layer.cornerRadius = contentViewCornerRadius
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)

        dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.font = UIFont._16MediumFont
        containerView.addSubview(dateLabel)

        checkedImage = UIImage(named: checkedImageName)
        uncheckedImage = UIImage(named: uncheckedImageName)

        checkBoxImageView = UIImageView()
        checkBoxImageView.image = uncheckedImage
        checkBoxImageView.contentMode = .scaleAspectFit
        containerView.addSubview(checkBoxImageView)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(containerViewHeight)
        }

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
    func configure(for pollsDateAttendanceModel: PollsDateAttendanceModel) {
        dateLabel.text = reformatDate(pollsDateAttendanceModel.model.dateValue)
        checkBoxImageView.image = pollsDateAttendanceModel.isSelected ? checkedImage : uncheckedImage
    }

    // MARK: - Helpers
    // Converts date to MMMM d format
    func reformatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
