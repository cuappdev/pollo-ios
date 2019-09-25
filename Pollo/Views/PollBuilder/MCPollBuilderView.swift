//
//  MCPollBuilderView.swift
//  Pollo
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SnapKit
import UIKit

protocol MCPollBuilderViewDelegate: class {
    var drafts: [Draft] { get }
    func shouldEditDraft(draft: Draft)
    func loadDraft(draft: Draft)
}

class MCPollBuilderView: UIView {
    
    // MARK: - View vars
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - Data vars
    var askQuestionModel: AskQuestionModel!
    var draftsTitleModel: DraftsTitleModel?
    var editable: Bool!
    var grayViewBottomConstraint: Constraint!
    var mcOptionModels: [PollBuilderMCOptionModel]!
    var session: Session!
    weak var delegate: MCPollBuilderViewDelegate?
    weak var pollBuilderDelegate: PollBuilderViewDelegate?

    var questionText: String? {
        guard let sectionController = adapter.sectionController(forSection: 0) as? AskQuestionSectionController else {
            return nil
        }
        return sectionController.getTextFieldText()
    }

    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        clearMCOptionModels()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)

        askQuestionModel = AskQuestionModel(currentQuestion: nil)

        setupViews()
        setupConstraints()
        editable = false
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
    
    func getChoices() -> [PollResult] {
        return mcOptionModels.compactMap { (mcOptionModel) -> PollResult? in
            switch mcOptionModel.type {
            case .newOption(option: let option, index: let index, isCorrect: _):
                let letter = intToMCOption(index)
                return PollResult(letter: letter, text: option != "" ? option : letter, count: 0)
            case .addOption:
                return nil
            }
        }
    }

    func getOptions() -> [String] {
        return mcOptionModels.compactMap { (mcOptionModel) -> String? in
            switch mcOptionModel.type {
            case .newOption(option: let option, index: let index, isCorrect: _):
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
            make.width.centerX.top.bottom.equalToSuperview()
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

    func shouldLightenDraftsText(_ shouldLighten: Bool) {
        guard let draftsTitleModel = draftsTitleModel,
            let sectionController = adapter.sectionController(for: draftsTitleModel) as? DraftsTitleSectionController else {
                return
        }
        sectionController.shouldLightenText(shouldLighten)
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 70, right: 0.0)
            collectionView.contentInset = contentInsets
            collectionView.superview?.layoutIfNeeded()
            shouldLightenDraftsText(true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            collectionView.contentInset = .zero
            collectionView.superview?.layoutIfNeeded()
            shouldLightenDraftsText(false)
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
