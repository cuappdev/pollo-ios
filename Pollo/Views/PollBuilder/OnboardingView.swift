//
//  OnboardingView.swift
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
    var transitionButton: UIButton!
    private let addOptionLabel = UILabel()
    private let addOptionView = UIView()
    private let animatedLabel = UILabel()
    private let askQuestionBorder = UIView()
    private let askQuestionLabel = UILabel()
    private let buttonLabel = UILabel()
    private let buttonView = UIView()
    private let continueLabel = UILabel()
    private let firstCorrectView = UIView()
    private let firstOptionLabel = UILabel()
    private let firstOptionView = UIView()
    private let plusLabel = UILabel()
    private let secondCorrectView = UIView()
    private let secondOptionLabel = UILabel()
    private let secondOptionView = UIView()
    private let welcomeContainerView = UIView()
    private let welcomeDescriptionLabel = UILabel()
    private let welcomeTitleLabel = UILabel()
    
    // MARK: - Data vars
    var containerFrame: CGRect!
    var isTransitioning = false
    var shouldTransition = true
    var stage: OnboardingStage = .welcome

    // MARK: - Constants
    let aboutQuizModeLabelLeftPadding: CGFloat = 10
    let aboutQuizModeLabelText = "To use quiz mode, tap to set a correct answer"
    let aboutQuizModeLabelWidth: CGFloat = 176.5
    let addOptionLabelText = "Add Option"
    let askQuestionBorderHeight: CGFloat = 2
    let askQuestionBorderTopOffset: CGFloat = 5
    let askQuestionLabelHorizontalInset: CGFloat = 23
    let askQuestionLabelText = "Ask a question..."
    let buttonViewBorderWidth: CGFloat = 2
    let buttonViewHeight: CGFloat = 47.5
    let buttonViewWidth: CGFloat = 161
    let circleImageViewLength: CGFloat = 23.0
    let circleImageViewName = "whiteEmptyCircle"
    let continueLabelText = "Tap anywhere to continue"
    let continueLabelTopOffset: CGFloat = 40
    let correctViewBorderWidth: CGFloat = 2
    let correctViewLeadingOffset: CGFloat = 12
    let correctViewLength: CGFloat = 23
    let firstOptionTextAutofilled = "A"
    let firstOptionTextRegular = "Option A"
    let optionLabelLeadingOffset: CGFloat = 8
    let optionViewBorderWidth: CGFloat = 2
    let optionViewCornerRadius: CGFloat = 5
    let plusLabelText = "+"
    let saveDraftText = "Save as draft"
    let secondOptionTextAutofilled = "B"
    let secondOptionTextRegular = "Option B"
    let startQuestionText = "Start Poll"
    let welcomeDescriptionLabelHorizontalInset: CGFloat = 92
    let welcomeDescriptionLabelText = "Here are some tips to get you started."
    let welcomeDescriptionLabelTopOffset: CGFloat = 8
    let welcomeTitleLabelHorizontalInset: CGFloat = 85
    let welcomeTitleLabelText = "Welcome to your first poll!"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.6)
        
        addSubview(welcomeContainerView)
        
        welcomeTitleLabel.text = welcomeTitleLabelText
        welcomeTitleLabel.numberOfLines = 0
        welcomeTitleLabel.font = ._30BoldFont
        welcomeTitleLabel.textColor = .white
        welcomeTitleLabel.textAlignment = .center
        welcomeContainerView.addSubview(welcomeTitleLabel)
        
        welcomeDescriptionLabel.text = welcomeDescriptionLabelText
        welcomeDescriptionLabel.numberOfLines = 0
        welcomeDescriptionLabel.font = ._16RegularFont
        welcomeDescriptionLabel.textColor = .white
        welcomeDescriptionLabel.textAlignment = .center
        welcomeContainerView.addSubview(welcomeDescriptionLabel)
        
        continueLabel.text = continueLabelText
        continueLabel.font = ._20BoldFont
        continueLabel.textColor = .white
        continueLabel.textAlignment = .center
        welcomeContainerView.addSubview(continueLabel)
        
        askQuestionLabel.text = askQuestionLabelText
        askQuestionLabel.font = ._18RegularFont
        askQuestionLabel.textColor = .white
        askQuestionLabel.alpha = 0
        addSubview(askQuestionLabel)
        
        askQuestionBorder.backgroundColor = .white
        askQuestionBorder.alpha = 0
        addSubview(askQuestionBorder)
        
        firstOptionView.backgroundColor = .clear
        firstOptionView.clipsToBounds = true
        firstOptionView.layer.borderColor = UIColor.white.cgColor
        firstOptionView.layer.borderWidth = optionViewBorderWidth
        firstOptionView.layer.cornerRadius = optionViewCornerRadius
        firstOptionView.alpha = 0
        addSubview(firstOptionView)
        
        firstCorrectView.backgroundColor = .clear
        firstCorrectView.clipsToBounds = true
        firstCorrectView.layer.cornerRadius = correctViewLength / 2
        firstCorrectView.layer.borderColor = UIColor.white.cgColor
        firstCorrectView.layer.borderWidth = correctViewBorderWidth
        firstCorrectView.alpha = 0
        addSubview(firstCorrectView)
        
        firstOptionLabel.text = firstOptionTextRegular
        firstOptionLabel.font = ._16RegularFont
        firstOptionLabel.textColor = .white
        firstOptionLabel.alpha = 0
        addSubview(firstOptionLabel)
        
        secondOptionView.backgroundColor = .clear
        secondOptionView.clipsToBounds = true
        secondOptionView.layer.borderColor = UIColor.white.cgColor
        secondOptionView.layer.borderWidth = optionViewBorderWidth
        secondOptionView.layer.cornerRadius = optionViewCornerRadius
        secondOptionView.alpha = 0
        addSubview(secondOptionView)
        
        secondCorrectView.backgroundColor = .clear
        secondCorrectView.clipsToBounds = true
        secondCorrectView.layer.cornerRadius = correctViewLength / 2
        secondCorrectView.layer.borderColor = UIColor.white.cgColor
        secondCorrectView.layer.borderWidth = correctViewBorderWidth
        secondCorrectView.alpha = 0
        addSubview(secondCorrectView)
        
        secondOptionLabel.text = secondOptionTextRegular
        secondOptionLabel.font = ._16RegularFont
        secondOptionLabel.textColor = .white
        secondOptionLabel.alpha = 0
        addSubview(secondOptionLabel)
        
        addOptionView.backgroundColor = .clear
        addOptionView.clipsToBounds = true
        addOptionView.layer.cornerRadius = optionViewCornerRadius
        addOptionView.layer.borderColor = UIColor.white.cgColor
        addOptionView.layer.borderWidth = optionViewBorderWidth
        addOptionView.alpha = 0
        addSubview(addOptionView)
        
        plusLabel.text = plusLabelText
        plusLabel.textColor = .white
        plusLabel.textAlignment = .center
        plusLabel.font = ._20BoldFont
        plusLabel.alpha = 0
        addSubview(plusLabel)
        
        addOptionLabel.text = addOptionLabelText
        addOptionLabel.textColor = .white
        addOptionLabel.font = ._16RegularFont
        addOptionLabel.alpha = 0
        addSubview(addOptionLabel)
        
        animatedLabel.textColor = .white
        animatedLabel.font = ._20BoldFont
        animatedLabel.numberOfLines = 0
        animatedLabel.alpha = 0
        addSubview(animatedLabel)
        
        buttonView.backgroundColor = .clear
        buttonView.clipsToBounds = true
        buttonView.layer.cornerRadius = buttonViewHeight / 2
        buttonView.layer.borderWidth = buttonViewBorderWidth
        buttonView.layer.borderColor = UIColor.white.cgColor
        buttonView.alpha = 0
        addSubview(buttonView)
        
        buttonLabel.text = startQuestionText
        buttonLabel.textColor = .white
        buttonLabel.font = ._16SemiboldFont
        buttonLabel.textAlignment = .center
        buttonLabel.alpha = 0
        addSubview(buttonLabel)

        transitionButton = UIButton()
        transitionButton.backgroundColor = .clear
        transitionButton.addTarget(self, action: #selector(transitionButtonTapped), for: .touchUpInside)
        addSubview(transitionButton)
    }
    
    func getAnimatedLabelText() -> String {
        if stage == .createQuestion {
            return "To customize this question, type here and add additional options"
        } else if stage == .autofillChoices {
            return "To autofill choices A, B, ... , tap here to start live polling"
        } else if stage == .quizMode {
            return "To use quiz mode, select a correct answer"
        } else if stage == .saveDraft {
            return "To come back to this question, tap here"
        } else if stage == .startQuestion {
            return "To start polling now, tap here"
        }
        return "That's it! You're good to go."
    }
    
    func setupConstraints() {
        let welcomeTitleLabelHeight = welcomeTitleLabelText.height(withConstrainedWidth: frame.width - welcomeTitleLabelHorizontalInset * 2, font: welcomeTitleLabel.font)
        let welcomeDescriptionLabelHeight = welcomeDescriptionLabelText.height(withConstrainedWidth: frame.width - welcomeDescriptionLabelHorizontalInset * 2, font: welcomeDescriptionLabel.font)
        let continueLabelHeight = continueLabelText.height(withConstrainedWidth: frame.width, font: continueLabel.font)
        let welcomeContainerViewHeight = welcomeTitleLabelHeight + welcomeDescriptionLabelTopOffset + welcomeDescriptionLabelHeight + continueLabelTopOffset + continueLabelHeight
        welcomeContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(welcomeContainerViewHeight)
            make.center.equalToSuperview()
        }
        
        welcomeTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-welcomeTitleLabelHorizontalInset * 2)
        }
        
        welcomeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitleLabel.snp.bottom).offset(welcomeDescriptionLabelTopOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-welcomeDescriptionLabelHorizontalInset * 2)
        }
        
        continueLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeDescriptionLabel.snp.bottom).offset(continueLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        askQuestionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(containerFrame.origin.y - 4)
            make.leading.equalToSuperview().offset(askQuestionLabelHorizontalInset)
        }
        
        askQuestionBorder.snp.makeConstraints { make in
            make.leading.equalTo(askQuestionLabel)
            make.trailing.equalToSuperview().inset(askQuestionLabelHorizontalInset)
            make.height.equalTo(askQuestionBorderHeight)
            make.top.equalTo(askQuestionLabel.snp.bottom).offset(askQuestionBorderTopOffset)
        }
        
        firstOptionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(askQuestionBorder.snp.bottom).offset(11)
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(47)
        }
        
        firstCorrectView.snp.makeConstraints { make in
            make.width.height.equalTo(correctViewLength)
            make.centerY.equalTo(firstOptionView)
            make.leading.equalTo(firstOptionView).offset(correctViewLeadingOffset)
        }
        
        firstOptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstCorrectView)
            make.leading.equalTo(firstCorrectView.snp.trailing).offset(optionLabelLeadingOffset)
        }
        
        secondOptionView.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(firstOptionView)
            make.top.equalTo(firstOptionView.snp.bottom).offset(6)
        }
        
        secondCorrectView.snp.makeConstraints { make in
            make.width.height.equalTo(correctViewLength)
            make.centerY.equalTo(secondOptionView)
            make.leading.equalTo(secondOptionView).offset(correctViewLeadingOffset)
        }
        
        secondOptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(secondCorrectView)
            make.leading.equalTo(secondCorrectView.snp.trailing).offset(optionLabelLeadingOffset)
        }
        
        addOptionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(firstOptionView)
            make.height.equalTo(53)
            make.top.equalTo(secondOptionView.snp.bottom).offset(6)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.leading.equalTo(addOptionView).offset(18)
            make.centerY.equalTo(addOptionView)
        }
        
        addOptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusLabel.snp.trailing).offset(6.5)
            make.centerY.equalTo(addOptionView)
        }
        
        animatedLabel.snp.makeConstraints { make in
            make.top.equalTo(addOptionView.snp.bottom).offset(11)
            make.leading.trailing.equalTo(addOptionView)
        }
        
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(buttonViewWidth)
            make.height.equalTo(buttonViewHeight)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.trailing.equalToSuperview().inset(18)
        }
        
        buttonLabel.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }

        transitionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func transitionButtonTapped() {
        if !shouldTransition { return }
        shouldTransition = false
        switch stage {
        case .welcome:
            stage = .createQuestion
            animatedLabel.text = getAnimatedLabelText()
            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeContainerView.alpha = 0
                self.askQuestionLabel.alpha = 1
                self.askQuestionBorder.alpha = 1
                self.firstOptionView.alpha = 1
                self.firstCorrectView.alpha = 1
                self.firstOptionLabel.alpha = 1
                self.secondOptionView.alpha = 1
                self.secondCorrectView.alpha = 1
                self.secondOptionLabel.alpha = 1
                self.addOptionView.alpha = 1
                self.plusLabel.alpha = 1
                self.addOptionLabel.alpha = 1
                self.animatedLabel.alpha = 1
            }) { completed in
                if completed {
                    self.shouldTransition = true
                }
            }
        case .createQuestion:
            stage = .autofillChoices
            animatedLabel.text = getAnimatedLabelText()
            firstOptionLabel.text = firstOptionTextAutofilled
            secondOptionLabel.text = secondOptionTextAutofilled
            animatedLabel.textAlignment = .right
            UIView.animate(withDuration: 0.5, animations: {
                self.askQuestionLabel.alpha = 0
                self.askQuestionBorder.alpha = 0
                self.addOptionView.alpha = 0
                self.plusLabel.alpha = 0
                self.addOptionLabel.alpha = 0
                self.buttonView.alpha = 1
                self.buttonLabel.alpha = 1
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.leading.equalToSuperview().offset(89)
                    remake.trailing.equalTo(self.firstOptionView).inset(16)
                    remake.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-67.5)
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.shouldTransition = true
                }
            }
        case .autofillChoices:
            stage = .quizMode
            UIView.animate(withDuration: 0.5, animations: {
                self.firstOptionView.alpha = 0
                self.firstOptionLabel.alpha = 0
                self.secondOptionView.alpha = 0
                self.secondOptionLabel.alpha = 0
                self.buttonView.alpha = 0
                self.buttonLabel.alpha = 0
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.leading.equalTo(self.firstCorrectView.snp.trailing).offset(self.optionLabelLeadingOffset)
                    remake.top.equalTo(self.firstCorrectView).offset(-5)
                    remake.trailing.equalToSuperview().inset(92)
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.animatedLabel.text = self.getAnimatedLabelText()
                    self.animatedLabel.textAlignment = .left
                    self.shouldTransition = true
                }
            }
        case .quizMode:
            stage = .saveDraft
            animatedLabel.text = getAnimatedLabelText()
            buttonLabel.text = saveDraftText
            buttonView.snp.remakeConstraints { remake in
                remake.width.equalTo(buttonViewWidth)
                remake.height.equalTo(buttonViewHeight)
                remake.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
                remake.leading.equalToSuperview().offset(18)
            }
            buttonLabel.snp.remakeConstraints { remake in
                remake.center.equalTo(buttonView)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.firstCorrectView.alpha = 0
                self.secondCorrectView.alpha = 0
                self.buttonView.alpha = 1
                self.buttonLabel.alpha = 1
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.leading.equalTo(self.buttonView)
                    remake.bottom.equalTo(self.buttonView.snp.top).offset(-5)
                    remake.trailing.equalToSuperview().inset(130)
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.shouldTransition = true
                }
            }
        case .saveDraft:
            stage = .startQuestion
            animatedLabel.text = getAnimatedLabelText()
            animatedLabel.textAlignment = .right
            buttonLabel.text = startQuestionText
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonView.snp.remakeConstraints { remake in
                    remake.width.equalTo(self.buttonViewWidth)
                    remake.height.equalTo(self.buttonViewHeight)
                    remake.trailing.equalToSuperview().inset(18)
                    remake.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
                }
                self.buttonLabel.snp.remakeConstraints { remake in
                    remake.center.equalTo(self.buttonView)
                }
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.trailing.equalToSuperview().inset(20)
                    remake.bottom.equalTo(self.buttonView.snp.top).offset(-5)
                    remake.leading.equalToSuperview().offset(177)
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.shouldTransition = true
                }
            }
        case .startQuestion:
            stage = .finished
            animatedLabel.text = getAnimatedLabelText()
            animatedLabel.font = ._30BoldFont
            animatedLabel.textAlignment = .center
            UIView.animate(withDuration: 0.5) {
                self.buttonView.alpha = 0
                self.buttonLabel.alpha = 0
            }
            animatedLabel.snp.remakeConstraints { remake in
                remake.width.equalToSuperview().multipliedBy(0.75)
                remake.center.equalToSuperview()
            }
            shouldTransition = true
        case .finished:
            removeFromSuperview()
        }
    }

    func configure(with frame: CGRect) {
        containerFrame = frame
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
