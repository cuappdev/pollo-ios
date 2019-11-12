//
//  QuizModeOverlayView.swift
//  Pollo
//
//  Created by Kevin Chan on 10/26/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

enum OnboardingStage {
    case welcome
    case createQuestion
    case autofillChoices
    case quizMode
    case saveDraft
    case startQuestion
    case finished
}

class OnboardingView: UIView {

    // MARK: - View vars
    var aboutQuizModeLabel: UILabel!
    var circleImageView: UIImageView!
    var dismissButton: UIButton!
    var dismissTimer: Timer!
    
    // MARK: - Data vars
    var isTransitioning = false
    var stage: OnboardingStage = .welcome

    // MARK: - Constants
    let aboutQuizModeLabelLeftPadding: CGFloat = 10
    let aboutQuizModeLabelText = "To use quiz mode, tap to set a correct answer"
    let aboutQuizModeLabelWidth: CGFloat = 176.5
    let circleImageViewLength: CGFloat = 23.0
    let circleImageViewName = "whiteEmptyCircle"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.6)

        circleImageView = UIImageView()
        circleImageView.image = UIImage(named: circleImageViewName)
        circleImageView.contentMode = .scaleAspectFit
        addSubview(circleImageView)

        aboutQuizModeLabel = UILabel()
        aboutQuizModeLabel.text = aboutQuizModeLabelText
        aboutQuizModeLabel.font = ._16SemiboldFont
        aboutQuizModeLabel.textColor = .white
        aboutQuizModeLabel.numberOfLines = 0
        aboutQuizModeLabel.lineBreakMode = .byWordWrapping
        addSubview(aboutQuizModeLabel)

        dismissButton = UIButton()
        dismissButton.backgroundColor = .clear
        dismissButton.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)
        addSubview(dismissButton)

        circleImageView.snp.makeConstraints { make in
            make.width.height.equalTo(circleImageViewLength)
            make.leading.top.equalToSuperview().offset(0)
        }

        aboutQuizModeLabel.snp.makeConstraints { make in
            make.width.equalTo(aboutQuizModeLabelWidth)
            make.centerY.equalTo(circleImageView.snp.centerY)
            make.leading.equalTo(circleImageView.snp.trailing).offset(aboutQuizModeLabelLeftPadding)
        }

        dismissButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        dismissTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (_) in
            self.removeFromSuperview()
        })
    }

    func configure(with frame: CGRect) {
        circleImageView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(frame.origin.x)
            make.top.equalToSuperview().offset(frame.origin.y)
        }
    }

    @objc func dismissBtnTapped() {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
