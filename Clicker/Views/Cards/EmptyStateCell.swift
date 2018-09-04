//
//  EmptyStateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class EmptyStateCell: UICollectionViewCell {
   
    //MARK: views!
    var monkeyView: UIImageView!
    var nothingToSeeLabel: UILabel!
    var waitingLabel: UILabel!
    var nameView: NameView!
    
    //MARK: TODO- implement these
    var session: Session!
    var userRole: UserRole!
    var nameViewDelegate: NameViewDelegate!

    // MARK: - Constants
    let monkeyViewLength: CGFloat = 32.0
    let monkeyViewTopPadding: CGFloat = 142.0
    let nothingToSeeLabelWidth: CGFloat = 200.0
    let nothingToSeeLabelTopPadding: CGFloat = 20.0
    let waitingLabelWidth: CGFloat = 220.0
    let waitingLabelTopPadding: CGFloat = 10.0
    let countLabelWidth: CGFloat = 42.0
    let adminNothingToSeeText = "Nothing to see here."
    let userNothingToSeeText = "Nothing to see yet."
    let adminWaitingText = "You haven't asked any polls yet!\nTry it out below."
    let userWaitingText = "Waiting for the host to post a poll."

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupViews()
        setupConstraints()
        print("setting up empty state cell with userRole = \(userRole), session=\(session)")
        // TODO: Add logic for setting up empty state or nonempty state
        if (userRole == .admin && session.name == session.code) {
            setupNameView()
        }
    }
    
    func setupViews() {
        monkeyView = UIImageView(image: #imageLiteral(resourceName: "monkey_emoji"))
        monkeyView.contentMode = .scaleAspectFit
        addSubview(monkeyView)
        
        nothingToSeeLabel = UILabel()
        nothingToSeeLabel.font = ._16SemiboldFont
        nothingToSeeLabel.textColor = .clickerGrey5
        nothingToSeeLabel.textAlignment = .center
        nothingToSeeLabel.text = userRole == .admin ? adminNothingToSeeText : userNothingToSeeText
        addSubview(nothingToSeeLabel)
        
        waitingLabel = UILabel()
        waitingLabel.font = ._14MediumFont
        waitingLabel.textColor = .clickerGrey2
        waitingLabel.textAlignment = .center
        waitingLabel.lineBreakMode = .byWordWrapping
        waitingLabel.numberOfLines = 0
        waitingLabel.text = userRole == .admin ? adminWaitingText : userWaitingText
        addSubview(waitingLabel)
        
    }
    func setupConstraints() {
        monkeyView.snp.makeConstraints { make in
            make.width.height.equalTo(monkeyViewLength)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(monkeyViewTopPadding)
        }
        
        nothingToSeeLabel.snp.makeConstraints { make in
            make.width.equalTo(nothingToSeeLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(monkeyView.snp.bottom).offset(nothingToSeeLabelTopPadding)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.width.equalTo(waitingLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(nothingToSeeLabel.snp.bottom).offset(waitingLabelTopPadding)
        }
    }
    // MARK - NAME THE POLL
    func setupNameView() {
        nameView = NameView(frame: .zero)
        nameView.session = session
        nameView.delegate = nameViewDelegate
        nameView.setup()
        addSubview(nameView)
        
        nameView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
