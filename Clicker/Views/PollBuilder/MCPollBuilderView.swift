//
//  MCPollBuilderView.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SnapKit
import UIKit

protocol MCPollBuilderViewDelegate {
    var drafts: [Draft] { get }
}

class MCPollBuilderView: UIView {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - Data vars
    var delegate: MCPollBuilderViewDelegate?
    var pollBuilderDelegate: PollBuilderViewDelegate?
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var editable: Bool!
    var askQuestionModel: AskQuestionModel!
    var mcOptionModels: [PollBuilderMCOptionModel]!
    var questionText: String? {
        guard let sectionController = adapter.sectionController(for: askQuestionModel) as? AskQuestionSectionController else {
            return nil
        }
        return sectionController.getTextFieldText()
    }

    // MARK: - Constants
    let collectionViewTopPadding: CGFloat = 10

    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        clearMCOptionModels()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)

        askQuestionModel = AskQuestionModel(currentQuestion: nil)

        setupViews()
        setupConstraints()
        editable = false
//        questionTextField.becomeFirstResponder()
    }
    
    func configure(with delegate: MCPollBuilderViewDelegate, pollBuilderDelegate: PollBuilderViewDelegate) {
        self.delegate = delegate
        self.pollBuilderDelegate = pollBuilderDelegate
        self.adapter.performUpdates(animated: false, completion: nil)
    }

    func needsPerformUpdates() {
        self.adapter.performUpdates(animated: false, completion: nil)
    }
    
    // MARK: - POLLING
    func reset() {
        askQuestionModel = AskQuestionModel(currentQuestion: nil)
        clearMCOptionModels()
        adapter.reloadData(completion: nil)
    }
    
    func clearMCOptionModels() {
        let firstOptionModel = PollBuilderMCOptionModel(type: PollBuilderMCOptionModelType.newOption(option: "", index: 0, isCorrect: false))
        let secondOptionModel = PollBuilderMCOptionModel(type: PollBuilderMCOptionModelType.newOption(option: "", index: 1, isCorrect: false))
        let addOptionModel = PollBuilderMCOptionModel(type: PollBuilderMCOptionModelType.addOption)
        mcOptionModels = [firstOptionModel, secondOptionModel, addOptionModel]
        updateTotalOptions()
    }
    
    func getOptions() -> [String] {
        return mcOptionModels.compactMap { (mcOptionModel) -> String? in
            switch mcOptionModel.type {
            case .newOption(option: let option, index: let index, isCorrect: let isCorrect):
                return option != "" ? option : intToMCOption(index)
            case .addOption:
                return nil
            }
        }
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clickerWhite
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = true
        addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(collectionViewTopPadding)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func hideKeyboard() {
        self.endEditing(true)
    }
    
    func fillDraft(title: String, options: [String]) {
        askQuestionModel = AskQuestionModel(currentQuestion: title)
        mcOptionModels = []
        options.enumerated().forEach { (arg) in
            let (index, option) = arg
            mcOptionModels.append(PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: false)))
        }
        mcOptionModels.append(PollBuilderMCOptionModel(type: .addOption))
        updateTotalOptions()
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func updateTotalOptions() {
        for opt in mcOptionModels {
            opt.totalOptions = mcOptionModels.count - 1
        }
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 70, 0.0)
            collectionView.contentInset = contentInsets
            collectionView.superview?.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            collectionView.contentInset = .zero
            collectionView.superview?.layoutIfNeeded()
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
