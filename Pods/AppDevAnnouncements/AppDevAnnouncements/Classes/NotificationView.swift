//
//  NotificationView.swift
//  AppDevAnnouncements
//
//  Created by Gonzalo Gonzalez on 10/16/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

internal class NotificationView: UIView {

    /// Components
    private let topPortionView = UIView()
    private let bottomPortionView = UIView()
    private let dismissButton = UIButton()
    private let visualImageView = UIImageView()
    private let subjectLabel = UILabel()
    private let bodyLabel = UILabel()
    private let ctaButton = UIButton()

    /// Constants
    internal enum Constants {
        static let baseTopPortionViewHeight: CGFloat = 74
        static let bodyLabelHorizontalPadding: CGFloat = 16
        static let bodyLabelTopPadding: CGFloat = 24
        static let ctaButtonBottomPadding: CGFloat = 16
        static let ctaButtonHeight: CGFloat = 38
        static let ctaButtonTopPadding: CGFloat = 16
        static let extraImageHeight: CGFloat = 97
        static let imageViewVerticalPadding: CGFloat = 16
        static let notificationViewWidth: CGFloat = 327
    }
    
    internal init(
        announcement: Announcement,
        dismissFunc: Selector,
        actionFunc: Selector,
        target: UIViewController
    ) {
        super.init(frame: .zero)

        /// Colors
        let lightGray = UIColor(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        let darkGray = UIColor(displayP3Red: 114/255, green: 114/255, blue: 114/255, alpha: 1)

        topPortionView.translatesAutoresizingMaskIntoConstraints = false
        topPortionView.backgroundColor = .white
        addSubview(topPortionView)

        bottomPortionView.translatesAutoresizingMaskIntoConstraints = false
        bottomPortionView.backgroundColor = lightGray
        addSubview(bottomPortionView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        let podBundle = Bundle(identifier: "org.cocoapods.AppDevAnnouncements")
        let dismissButtonImage = UIImage(named: "closeIcon", in: podBundle, compatibleWith: nil)
        dismissButton.setImage(dismissButtonImage, for: .normal)
        dismissButton.addTarget(target, action: dismissFunc, for: .touchUpInside)
        addSubview(dismissButton)

        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectLabel.textAlignment = .center
        subjectLabel.font = .systemFont(ofSize: 24, weight: .bold)
        subjectLabel.text = announcement.subject
        addSubview(subjectLabel)

        if let unwrappedUrl = announcement.imageUrl,
            announcement.imageHeight != nil,
            announcement.imageWidth != nil {
            visualImageView.translatesAutoresizingMaskIntoConstraints = false
            visualImageView.contentMode = .scaleAspectFit
            visualImageView.loadFrom(url: unwrappedUrl, completion: nil)
            addSubview(visualImageView)
        }

        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.numberOfLines = 0
        bodyLabel.backgroundColor = .clear
        bodyLabel.attributedText = Utils.attributedString(for: announcement.body)
        addSubview(bodyLabel)

        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.setTitle(announcement.ctaText, for: .normal)
        ctaButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.addTarget(target, action: actionFunc, for: .touchUpInside)
        ctaButton.backgroundColor = darkGray
        ctaButton.layer.cornerRadius = 5
        if let hexColor = announcement.ctaButtonColor {
            ctaButton.backgroundColor = Utils.getColor(hexString: hexColor)
        } else {
            ctaButton.backgroundColor = darkGray
        }
        addSubview(ctaButton)

        setupConstraints(announcement)
    }

    private func setupConstraints(_ announcement: Announcement) {
        let dismissButtonPadding: CGFloat = 12
        let dismissButtonLength: CGFloat = 12
        let subjectLabelTopPadding: CGFloat = 32
        let subjectLabelHorizontalPadding: CGFloat = 24
        let subjectLabelHeight: CGFloat = 31
        let ctaButtonHorizontalPadding: CGFloat = 24

        NSLayoutConstraint.activate([
            topPortionView.topAnchor.constraint(equalTo: topAnchor),
            topPortionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topPortionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topPortionView.widthAnchor.constraint(equalTo: widthAnchor),
            topPortionView.heightAnchor.constraint(equalToConstant: topPortionViewHeight(announcement))
        ])

        NSLayoutConstraint.activate([
            bottomPortionView.topAnchor.constraint(equalTo: topPortionView.bottomAnchor),
            bottomPortionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomPortionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomPortionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: dismissButtonPadding),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: dismissButtonPadding),
            dismissButton.widthAnchor.constraint(equalToConstant: dismissButtonLength),
            dismissButton.heightAnchor.constraint(equalToConstant: dismissButtonLength)
        ])

        NSLayoutConstraint.activate([
            subjectLabel.topAnchor.constraint(equalTo: topPortionView.topAnchor, constant: subjectLabelTopPadding),
            subjectLabel.leadingAnchor.constraint(equalTo: topPortionView.leadingAnchor, constant: subjectLabelHorizontalPadding),
            subjectLabel.trailingAnchor.constraint(equalTo: topPortionView.trailingAnchor, constant: -subjectLabelHorizontalPadding),
            subjectLabel.heightAnchor.constraint(equalToConstant: subjectLabelHeight)
        ])

        if announcement.imageUrl != nil,
            let imageHeight = announcement.imageHeight,
            let imageWidth = announcement.imageWidth {
            NSLayoutConstraint.activate([
                visualImageView.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: Constants.imageViewVerticalPadding),
                visualImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                visualImageView.widthAnchor.constraint(equalToConstant: CGFloat(imageWidth)),
                visualImageView.heightAnchor.constraint(equalToConstant: CGFloat(imageHeight))
            ])
        }

        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: bottomPortionView.topAnchor, constant: Constants.bodyLabelTopPadding),
            bodyLabel.leadingAnchor.constraint(equalTo: bottomPortionView.leadingAnchor, constant: Constants.bodyLabelHorizontalPadding),
            bodyLabel.trailingAnchor.constraint(equalTo: bottomPortionView.trailingAnchor, constant: -Constants.bodyLabelHorizontalPadding),
            bodyLabel.heightAnchor.constraint(equalToConstant: bodyLabelHeight(announcement))
        ])

        NSLayoutConstraint.activate([
            ctaButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: Constants.ctaButtonTopPadding),
            ctaButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ctaButtonHorizontalPadding),
            ctaButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ctaButtonHorizontalPadding),
            ctaButton.heightAnchor.constraint(equalToConstant: Constants.ctaButtonHeight)
        ])
    }

    private func topPortionViewHeight(_ announcement: Announcement) -> CGFloat {
        let imageHeight = CGFloat(announcement.imageHeight ?? 0)
        return announcement.imageUrl == nil
            ? Constants.baseTopPortionViewHeight
            : Constants.baseTopPortionViewHeight + imageHeight + Constants.imageViewVerticalPadding * 2
    }

    private func bodyLabelHeight(_ announcement: Announcement) -> CGFloat {
        let bodyLabelWidth = Constants.notificationViewWidth - Constants.bodyLabelHorizontalPadding * 2
        return Utils.getTextHeight(for: Utils.attributedString(for: announcement.body), withConstrainedWidth: bodyLabelWidth)
    }

    internal func getTotalHeight(_ announcement: Announcement) -> CGFloat {
        let bottomPortionViewHeight =  Constants.bodyLabelTopPadding + bodyLabelHeight(announcement) + Constants.ctaButtonTopPadding + Constants.ctaButtonHeight + Constants.ctaButtonBottomPadding
        return topPortionViewHeight(announcement) + bottomPortionViewHeight
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
