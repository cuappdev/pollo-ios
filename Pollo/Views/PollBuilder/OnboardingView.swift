//
//  OnboardingView.swift
//  Pollo
//
//  Created by Kevin Chan on 10/26/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

private enum OnboardingStage {
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
    private let transitionButton = UIButton()
    private let welcomeContainerView = UIView()
    private let welcomeDescriptionLabel = UILabel()
    private let welcomeTitleLabel = UILabel()
    
    // MARK: - Data vars
    var containerFrame: CGRect!
    var isTransitioning = true
    fileprivate var stage: OnboardingStage = .welcome

    // MARK: - Constants
    let addOptionLabelText = "Add Option"
    let animatedLabelBottomOffset: CGFloat = 67.5
    let animatedLabelBottomSmallOffset: CGFloat = 5
    let animatedLabelHorizontalInset: CGFloat = 85
    let animationDuration: TimeInterval = 0.3
    let askQuestionLabelText = "Ask a question..."
    let buttonViewBorderWidth: CGFloat = 2
    let buttonViewBottomOffset: CGFloat = 10
    let buttonViewHeight: CGFloat = 47.5
    let buttonViewHorizontalPadding: CGFloat = 18
    let buttonViewWidth: CGFloat = 161
    let continueLabelText = "Tap anywhere to continue"
    let correctViewBorderWidth: CGFloat = 2
    let correctViewLength: CGFloat = 23
    let firstOptionTextAutofilled = "A"
    let firstOptionTextRegular = "Option A"
    let optionViewBorderWidth: CGFloat = 2
    let optionViewCornerRadius: CGFloat = 5
    let plusLabelText = "+"
    let saveDraftText = "Save as draft"
    let secondOptionTextAutofilled = "B"
    let secondOptionTextRegular = "Option B"
    let startQuestionText = "Start Poll"
    let welcomeDescriptionLabelText = "Here are some tips to get you started."
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

        transitionButton.backgroundColor = .clear
        transitionButton.addTarget(self, action: #selector(transitionButtonTapped), for: .touchUpInside)
        addSubview(transitionButton)
    }
    
    func getAnimatedLabelText() -> String {
        switch stage {
        case .welcome:
            return ""
        case .createQuestion:
            return "To customize this question, type here and add additional options"
        case .autofillChoices:
            return "To autofill choices A, B, ... , tap here to start live polling"
        case .quizMode:
            return "To use quiz mode, select a correct answer"
        case .saveDraft:
            return "To come back to this question, tap here"
        case .startQuestion:
            return "To start polling now, tap here"
        case .finished:
            return "That's it! You're good to go."
        }
    }
    
    func setupConstraints() {
        let addOptionLabelLeadingOffset: CGFloat = 6.5
        let addOptionViewHeight: CGFloat = 53
        let addOptionViewTopOffset: CGFloat = 6
        let animatedLabelTopOffset: CGFloat = 11
        let askQuestionBorderHeight: CGFloat = 2
        let askQuestionBorderTopOffset: CGFloat = 5
        let askQuestionLabelHorizontalInset: CGFloat = 23
        let askQuestionLabelTopOffset: CGFloat = 4
        let continueLabelTopOffset: CGFloat = 40
        let correctViewLeadingOffset: CGFloat = 12
        let firstOptionViewTopOffset: CGFloat = 11
        let minAnimatedLabelHeight: CGFloat = 53
        let optionHorizontalPadding: CGFloat = 18
        let optionLabelLeadingOffset: CGFloat = 8
        let optionViewHeight: CGFloat = 47
        let plusLabelWidth: CGFloat = 13
        let secondOptionViewTopOffset: CGFloat = 6
        let welcomeDescriptionLabelHorizontalInset: CGFloat = 92
        let welcomeDescriptionLabelTopOffset: CGFloat = 8
        let welcomeTitleLabelHorizontalInset: CGFloat = 85
        
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
            make.top.equalToSuperview().offset(containerFrame.origin.y - askQuestionLabelTopOffset)
            make.leading.equalToSuperview().offset(askQuestionLabelHorizontalInset)
        }
        
        askQuestionBorder.snp.makeConstraints { make in
            make.leading.equalTo(askQuestionLabel)
            make.trailing.equalToSuperview().inset(askQuestionLabelHorizontalInset)
            make.height.equalTo(askQuestionBorderHeight)
            make.top.equalTo(askQuestionLabel.snp.bottom).offset(askQuestionBorderTopOffset)
        }
        
        firstOptionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(optionHorizontalPadding)
            make.top.equalTo(askQuestionBorder.snp.bottom).offset(firstOptionViewTopOffset)
            make.trailing.equalToSuperview().inset(optionHorizontalPadding)
            make.height.equalTo(optionViewHeight)
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
            make.top.equalTo(firstOptionView.snp.bottom).offset(secondOptionViewTopOffset)
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
            make.height.equalTo(addOptionViewHeight)
            make.top.equalTo(secondOptionView.snp.bottom).offset(addOptionViewTopOffset)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.width.equalTo(plusLabelWidth)
            make.leading.equalTo(addOptionView).offset(optionHorizontalPadding)
            make.centerY.equalTo(addOptionView)
        }
        
        addOptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusLabel.snp.trailing).offset(addOptionLabelLeadingOffset)
            make.centerY.equalTo(addOptionView)
        }
        
        animatedLabel.snp.makeConstraints { make in
            make.top.equalTo(addOptionView.snp.bottom).offset(animatedLabelTopOffset)
            make.leading.trailing.equalTo(addOptionView)
            make.height.greaterThanOrEqualTo(minAnimatedLabelHeight)
        }
        
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(buttonViewWidth)
            make.height.equalTo(buttonViewHeight)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-buttonViewBottomOffset)
            make.trailing.equalToSuperview().inset(buttonViewHorizontalPadding)
        }
        
        buttonLabel.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }

        transitionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getAnimatedLabelLeadingOffset() -> CGFloat {
        if stage == .autofillChoices {
            return 89
        } else if stage == .quizMode {
            return 18
        }
        return 177
    }
    
    func getAnimatedLabelTrailingInset() -> CGFloat {
        if stage == .autofillChoices {
            return 16
        } else if stage == .quizMode {
            return 92
        } else if stage == .saveDraft {
            return 130
        }
        return 20
    }
    
    @objc func transitionButtonTapped() {
        if !isTransitioning { return }
        isTransitioning = false
        switch stage {
        case .welcome:
            stage = .createQuestion
            animatedLabel.text = getAnimatedLabelText()
            UIView.animate(withDuration: animationDuration, animations: {
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
                    self.isTransitioning = true
                }
            }
        case .createQuestion:
            stage = .autofillChoices
            animatedLabel.text = getAnimatedLabelText()
            firstOptionLabel.text = firstOptionTextAutofilled
            secondOptionLabel.text = secondOptionTextAutofilled
            animatedLabel.textAlignment = .right
            UIView.animate(withDuration: animationDuration, animations: {
                self.askQuestionLabel.alpha = 0
                self.askQuestionBorder.alpha = 0
                self.addOptionView.alpha = 0
                self.plusLabel.alpha = 0
                self.addOptionLabel.alpha = 0
                self.buttonView.alpha = 1
                self.buttonLabel.alpha = 1
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.leading.equalToSuperview().offset(self.getAnimatedLabelLeadingOffset())
                    remake.trailing.equalTo(self.firstOptionView).inset(self.getAnimatedLabelTrailingInset())
                    remake.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-self.animatedLabelBottomOffset)
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.isTransitioning = true
                }
            }
        case .autofillChoices:
            stage = .quizMode
            animatedLabel.text = getAnimatedLabelText()
            animatedLabel.textAlignment = .left
            UIView.animate(withDuration: animationDuration, animations: {
                self.firstOptionView.alpha = 0
                self.firstOptionLabel.alpha = 0
                self.secondOptionView.alpha = 0
                self.secondOptionLabel.alpha = 0
                self.buttonView.alpha = 0
                self.buttonLabel.alpha = 0
                self.animatedLabel.snp.remakeConstraints { remake in
                remake.leading.equalTo(self.firstCorrectView.snp.trailing).offset(self.getAnimatedLabelLeadingOffset())
                    remake.top.equalTo(self.firstCorrectView).offset(-self.animatedLabelBottomSmallOffset)
                    remake.trailing.equalToSuperview().inset(self.getAnimatedLabelTrailingInset())
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.isTransitioning = true
                }
            }
        case .quizMode:
            stage = .saveDraft
            animatedLabel.text = getAnimatedLabelText()
            buttonLabel.text = saveDraftText
            buttonView.snp.remakeConstraints { remake in
                remake.width.equalTo(buttonViewWidth)
                remake.height.equalTo(buttonViewHeight)
                remake.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-self.buttonViewBottomOffset)
                remake.leading.equalToSuperview().offset(self.buttonViewHorizontalPadding)
            }
            buttonLabel.snp.remakeConstraints { remake in
                remake.center.equalTo(buttonView)
            }
            UIView.animate(withDuration: animationDuration, animations: {
                self.firstCorrectView.alpha = 0
                self.secondCorrectView.alpha = 0
                self.buttonView.alpha = 1
                self.buttonLabel.alpha = 1
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.leading.equalTo(self.buttonView)
                    remake.bottom.equalTo(self.buttonView.snp.top).offset(-self.animatedLabelBottomSmallOffset)
                    remake.trailing.equalToSuperview().inset(self.getAnimatedLabelTrailingInset())
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.isTransitioning = true
                }
            }
        case .saveDraft:
            stage = .startQuestion
            animatedLabel.text = getAnimatedLabelText()
            animatedLabel.textAlignment = .right
            buttonLabel.text = startQuestionText
            UIView.animate(withDuration: animationDuration, animations: {
                self.buttonView.snp.remakeConstraints { remake in
                    remake.width.equalTo(self.buttonViewWidth)
                    remake.height.equalTo(self.buttonViewHeight)
                    remake.trailing.equalToSuperview().inset(self.buttonViewHorizontalPadding)
                    remake.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-self.buttonViewBottomOffset)
                }
                self.buttonLabel.snp.remakeConstraints { remake in
                    remake.center.equalTo(self.buttonView)
                }
                self.animatedLabel.snp.remakeConstraints { remake in
                    remake.trailing.equalToSuperview().inset(self.getAnimatedLabelTrailingInset())
                    remake.bottom.equalTo(self.buttonView.snp.top).offset(-self.animatedLabelBottomSmallOffset)
                    remake.leading.equalToSuperview().offset(self.getAnimatedLabelLeadingOffset())
                }
                self.layoutIfNeeded()
            }) { completed in
                if completed {
                    self.isTransitioning = true
                }
            }
        case .startQuestion:
            stage = .finished
            animatedLabel.text = getAnimatedLabelText()
            animatedLabel.font = ._30BoldFont
            animatedLabel.textAlignment = .center
            UIView.animate(withDuration: animationDuration) {
                self.buttonView.alpha = 0
                self.buttonLabel.alpha = 0
            }
            animatedLabel.snp.remakeConstraints { remake in
                remake.width.equalToSuperview().offset(-animatedLabelHorizontalInset * 2)
                remake.center.equalToSuperview()
            }
            isTransitioning = true
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
