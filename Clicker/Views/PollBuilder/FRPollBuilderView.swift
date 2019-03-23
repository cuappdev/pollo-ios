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

protocol FRPollBuilderViewDelegate: class {
    var drafts: [Draft] { get }
    func shouldEditDraft(draft: Draft)
    func shouldLoadDraft(draft: Draft)
}

class FRPollBuilderView: UIView {
    
    // MARK: - View vars
    var adapter: ListAdapter!
    var collectionView: UICollectionView!
    
    // MARK: - Data vars
    var askQuestionModel: AskQuestionModel!
    var draftsTitleModel: DraftsTitleModel!
    var editable: Bool!
    var session: Session!
    weak var delegate: FRPollBuilderViewDelegate?
    weak var pollBuilderDelegate: PollBuilderViewDelegate?
    
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
        adapter.performUpdates(animated: false, completion: nil)
    }

    func fillDraft(title: String) {
        askQuestionModel = AskQuestionModel(currentQuestion: title)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clickerWhite
        collectionView.showsVerticalScrollIndicator = false
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
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
