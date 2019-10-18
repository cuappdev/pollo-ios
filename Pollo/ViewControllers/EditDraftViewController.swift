//
//  EditDraftViewController.swift
//  Pollo
//
//  Created by Matthew Coufal on 9/25/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol EditDraftViewControllerDelegate: class {
    func editDraftViewControllerDidTapDeleteDraftButton(draft: Draft)
}

class EditDraftViewController: UIViewController {

    // MARK: - View vars
    var deleteDraftButton: UIButton!
    var deleteDraftImageView: UIImageView!
    var deleteDraftLabel: UILabel!
    
    // MARK: - Data vars
    weak var delegate: EditDraftViewControllerDelegate?
    var draft: Draft!
    
    // MARK: - Constants
    let buttonHeight: CGFloat = 50
    let imageViewPadding: CGFloat = 18
    let deleteDraftLabelText: String = "Delete"
    
    init(delegate: EditDraftViewControllerDelegate, draft: Draft) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.draft = draft
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        deleteDraftButton = UIButton()
        deleteDraftButton.addTarget(self, action: #selector(deleteDraftButtonPressed), for: .touchUpInside)
        view.addSubview(deleteDraftButton)
        
        deleteDraftImageView = UIImageView()
        deleteDraftImageView.image = #imageLiteral(resourceName: "delete")
        view.addSubview(deleteDraftImageView)
        
        deleteDraftLabel = UILabel()
        deleteDraftLabel.text = deleteDraftLabelText
        deleteDraftLabel.textColor = .clickerRed
        deleteDraftLabel.font = ._16RegularFont
        view.addSubview(deleteDraftLabel)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
        deleteDraftButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        deleteDraftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(imageViewPadding)
            make.centerY.equalTo(deleteDraftButton.snp.centerY)
        }
        
        deleteDraftLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-imageViewPadding * 2)
            make.height.equalTo(deleteDraftButton.snp.height)
            make.left.equalTo(deleteDraftImageView.snp.right).offset(imageViewPadding)
        }
        
    }
    
    @objc func deleteDraftButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        delegate?.editDraftViewControllerDidTapDeleteDraftButton(draft: draft)
    }

}
