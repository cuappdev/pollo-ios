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

class MCPollBuilderView: UIView {
    
    // MARK: - View vars
    var questionTextField: UITextField!
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - Data vars
    var pollBuilderDelegate: PollBuilderViewDelegate!
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var editable: Bool!
    var mcOptionModels: [PollBuilderMCOptionModel]!
    
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
        
        setupViews()
        setupConstraints()
        editable = false
        questionTextField.becomeFirstResponder()
    }
    
    func configure(with delegate: PollBuilderViewDelegate) {
        self.pollBuilderDelegate = delegate
    }
    
    // MARK: - POLLING
    func reset() {
        questionTextField.text = ""
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
        questionTextField = UITextField()
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey2, NSAttributedStringKey.font: UIFont._18RegularFont])
        questionTextField.font = ._18RegularFont
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
        questionTextField.addTarget(self, action: #selector(updateEditable), for: .allEditingEvents)
        addSubview(questionTextField)
        
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
        questionTextField.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(questionTextField.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func updateEditable() {
        pollBuilderDelegate.updateCanDraft(questionTextField.text == "" ? false : true)
        editable = questionTextField.text == "" ? false : true
    }
    
    @objc func hideKeyboard() {
        self.endEditing(true)
    }
    
    func fillDraft(title: String, options: [String]) {
        questionTextField.text = title
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

extension MCPollBuilderView: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return mcOptionModels
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PollBuilderMCOptionSectionController(delegate: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension MCPollBuilderView: PollBuilderMCOptionSectionControllerDelegate {
    
    func pollBuilderSectionControllerShouldAddOption() {
        if mcOptionModels.count >= 27 { return }
        let newMCOptionModel = PollBuilderMCOptionModel(type: .newOption(option: "", index: mcOptionModels.count - 1, isCorrect: false))
        mcOptionModels.insert(newMCOptionModel, at: mcOptionModels.count - 1)
        updateTotalOptions()
        pollBuilderDelegate.ignoreNextKeyboardHiding()
        adapter.reloadData { _ in
            let index = IndexPath(item: 0, section: self.mcOptionModels.count - 2) // -2 because last CreateMCOptionCell is penultimate cell, with the add options button as the last cell.
            self.collectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            guard let cell = self.collectionView.cellForItem(at: index) as? CreateMCOptionCell else {
                print("thats not the right type of cell, something went wrong")
                return
            }
            cell.shouldFocusTextField()
        }
    }
    
    func pollBuilderSectionControllerDidUpdateOption(option: String, index: Int, isCorrect: Bool) {
        mcOptionModels[index].type = .newOption(option: option, index: index, isCorrect: isCorrect)
    }

    func pollBuilderSectionControllerDidUpdateIsCorrect(option: String, index: Int, isCorrect: Bool) {
        if isCorrect {
            var updatedMCOptionModels: [PollBuilderMCOptionModel] = []
            mcOptionModels.enumerated().forEach { (index, mcOptionModel) in
                switch mcOptionModel.type {
                case .newOption(option: let option, index: _, isCorrect: let isCorrect):
                    if isCorrect {
                        updatedMCOptionModels.append(PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: false)))
                    } else {
                        updatedMCOptionModels.append(mcOptionModel)
                    }
                case .addOption:
                    updatedMCOptionModels.append(mcOptionModel)
                }
            }
            mcOptionModels = updatedMCOptionModels
        }
        mcOptionModels[index] = PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: isCorrect))
        updateTotalOptions()
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func pollBuilderSectionControllerDidDeleteOption(index: Int) {
        if mcOptionModels.count <= 3 { return }
        mcOptionModels.remove(at: index)
        var updatedMCOptionModels: [PollBuilderMCOptionModel] = []
        mcOptionModels.enumerated().forEach { (index, mcOptionModel) in
            switch mcOptionModel.type {
            case .newOption(option: let option, index: _, isCorrect: let isCorrect):
                updatedMCOptionModels.append(PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: isCorrect)))
            case .addOption:
                updatedMCOptionModels.append(mcOptionModel)
            }
        }
        mcOptionModels = updatedMCOptionModels
        updateTotalOptions()
        pollBuilderDelegate.ignoreNextKeyboardHiding()
        
        adapter.performUpdates(animated: true) { _ in
            if self.pollBuilderDelegate.isKeyboardShown {
                // if deleted last option, select new last option. else, select new option at index of deleted option
                let newIndex = index == self.mcOptionModels.count - 1 ? self.mcOptionModels.count - 2 : index
                let selectIndex = IndexPath(item: 0, section: newIndex)
                self.collectionView.scrollToItem(at: selectIndex, at: .centeredVertically, animated: true)
                guard let cell = self.collectionView.cellForItem(at: selectIndex) as? CreateMCOptionCell else {
                    print("thats not the right type of cell, something went wrong")
                    return
                }
                cell.shouldFocusTextField()
            }
        }
    }
    
}

extension MCPollBuilderView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = IntegerConstants.maxQuestionCharacterCount
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}

extension MCPollBuilderView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return pollBuilderDelegate.isKeyboardShown
    }
    
}
