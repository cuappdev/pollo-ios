//
//  EditQuestionTypeViewController.swift
//  Clicker
//
//  Created by Matthew Coufal on 9/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol EditQuestionTypeDelegate {
    func editQuestionTypeViewControllerDidPick(questionType: QuestionType)
}

class EditQuestionTypeViewController: UIViewController {
    
    // MARK: - View vars
    var multipleChoiceButton: UIButton!
    var multipleChoiceLabel: UILabel!
    var freeResponseButton: UIButton!
    var freeResponseLabel: UILabel!
    var selectedDot: UIView!
    
    // MARK: - Data vars
    var delegate: EditQuestionTypeDelegate?
    var selectedQuestionType: QuestionType!
    
    // MARK: - Constants
    let dotDiameter: CGFloat = 15
    let dotPadding: CGFloat = 15
    let labelRightPadding: CGFloat = 45
    let labelLeftPadding: CGFloat = 15
    let buttonHeight: CGFloat = 50
    let multipleChoiceLabelText: String = "Multiple Choice"
    let freeResponseLabelText: String = "Free Response"
    
    init(selectedQuestionType: QuestionType) {
        super.init(nibName: nil, bundle: nil)
        self.selectedQuestionType = selectedQuestionType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        multipleChoiceButton = UIButton()
        multipleChoiceButton.addTarget(self, action: #selector(didPickMultipleChoice), for: .touchUpInside)
        view.addSubview(multipleChoiceButton)
        
        multipleChoiceLabel = UILabel()
        multipleChoiceLabel.text = multipleChoiceLabelText
        multipleChoiceLabel.textColor = selectedQuestionType == .multipleChoice ? .aquaMarine : .clickerBlack0
        multipleChoiceLabel.font = selectedQuestionType == .multipleChoice ? ._16SemiboldFont : ._16RegularFont
        view.addSubview(multipleChoiceLabel)
        
        freeResponseButton = UIButton()
        freeResponseButton.addTarget(self, action: #selector(didPickFreeResponse), for: .touchUpInside)
        view.addSubview(freeResponseButton)
        
        freeResponseLabel = UILabel()
        freeResponseLabel.text = freeResponseLabelText
        freeResponseLabel.textColor = selectedQuestionType == .freeResponse ? .aquaMarine : .clickerBlack0
        freeResponseLabel.font = selectedQuestionType == .freeResponse ? ._16SemiboldFont : ._16RegularFont
        view.addSubview(freeResponseLabel)
        
        selectedDot = UIView()
        selectedDot.backgroundColor = .aquaMarine
        selectedDot.clipsToBounds = true
        selectedDot.layer.cornerRadius = dotDiameter / 2
        view.addSubview(selectedDot)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        multipleChoiceButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height)
        }
        
        multipleChoiceLabel.snp.makeConstraints { make in
            make.width.equalTo(multipleChoiceButton.snp.width).offset(-labelLeftPadding - labelRightPadding)
            make.height.equalTo(multipleChoiceButton.snp.height).multipliedBy(0.75)
            make.left.equalToSuperview().offset(labelLeftPadding)
            make.bottom.equalTo(multipleChoiceButton.snp.bottom)
        }
        
        freeResponseButton.snp.makeConstraints { make in
            make.width.equalTo(multipleChoiceButton.snp.width)
            make.height.equalTo(multipleChoiceButton.snp.height)
            make.top.equalTo(multipleChoiceButton.snp.bottom)
        }
        
        freeResponseLabel.snp.makeConstraints { make in
            make.width.equalTo(multipleChoiceLabel.snp.width)
            make.height.equalTo(multipleChoiceLabel.snp.height)
            make.left.equalToSuperview().offset(labelLeftPadding)
            make.top.equalTo(freeResponseButton.snp.top)
        }
        
        selectedDot.snp.makeConstraints { make in
            make.width.equalTo(dotDiameter)
            make.height.equalTo(dotDiameter)
            make.right.equalToSuperview().offset(-dotPadding)
            make.centerY.equalTo(selectedQuestionType == .multipleChoice ? multipleChoiceLabel.snp.centerY : freeResponseLabel.snp.centerY)
        }
        
    }
    
    @objc func didPickMultipleChoice() {
        dismiss(animated: true, completion: nil)
        delegate?.editQuestionTypeViewControllerDidPick(questionType: .multipleChoice)
    }
    
    @objc func didPickFreeResponse() {
        dismiss(animated: true, completion: nil)
        delegate?.editQuestionTypeViewControllerDidPick(questionType: .freeResponse)
    }

}
