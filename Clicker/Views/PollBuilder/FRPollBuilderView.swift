//
//  FRPollBuilderView.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import SnapKit
import UIKit

protocol FRPollBuilderViewDelegate {
    var drafts: [Draft] { get }
    func shouldEditDraft(draft: Draft)
    func shouldLoadDraft(draft: Draft)
}

class FRPollBuilderView: UIView {
    
    // MARK: - View vars
    var questionTextField: UITextField!
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    
    // MARK: - Data vars
    var delegate: FRPollBuilderViewDelegate?
    var askQuestionModel: AskQuestionModel!
    var draftsTitleModel: DraftsTitleModel!
    var editable: Bool!
    var session: Session!
    var pollBuilderDelegate: PollBuilderViewDelegate!
    var questionText: String? {
        guard let sectionController = adapter.sectionController(for: askQuestionModel) as? AskQuestionSectionController else {
            return nil
        }
        return sectionController.getTextFieldText()
    }
    
    // MARK: - Constants
    let popupViewHeight: CGFloat = 95
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)

        askQuestionModel = AskQuestionModel(currentQuestion: nil)
        editable = false

        setupViews()
        setupConstraints()
    }

    func configure(with delegate: FRPollBuilderViewDelegate, pollBuilderDelegate: PollBuilderViewDelegate) {
        self.delegate = delegate
        self.pollBuilderDelegate = pollBuilderDelegate
        self.adapter.performUpdates(animated: false, completion: nil)
    }

    func needsPerformUpdates() {
        self.adapter.performUpdates(animated: false, completion: nil)
    }

    func reset() {
        askQuestionModel = AskQuestionModel(currentQuestion: nil)
        adapter.reloadData(completion: nil)
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
        collectionView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func updateEditable() {
        if editable {
            if questionTextField.text == "" {
                pollBuilderDelegate.updateCanDraft(false)
                editable = false
            }
        } else {
            if questionTextField.text != "" {
                pollBuilderDelegate.updateCanDraft(true)
                editable = true
            }
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
