//
//  ExportButtonCell.swift
//  Pollo
//
//  Created by Mindy Lou on 3/9/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import UIKit

protocol ExportButtonCellDelegate: class {
    func exportButtonCellButtonWasTapped()
}

class ExportButtonCell: UICollectionViewCell {

    // MARK: View vars
    var exportButton: UIButton!

    // MARK: Data vars
    weak var delegate: ExportButtonCellDelegate?

    // MARK: Constants
    let exportButtonBorderWidth: CGFloat = 1
    let exportButtonHeight: CGFloat = 47
    let exportButtonTitle = "Export"
    let exportButtonWidthScaleFactor: CGFloat = 0.43

    override init(frame: CGRect) {
        super.init(frame: frame)

        exportButton = UIButton()
        exportButton.setTitle(exportButtonTitle, for: .normal)
        exportButton.titleLabel?.font = ._16SemiboldFont
        exportButton.layer.cornerRadius = exportButtonHeight / 2.0
        exportButton.layer.borderWidth = exportButtonBorderWidth
        exportButton.addTarget(self, action: #selector(export), for: .touchUpInside)
        contentView.addSubview(exportButton)

        exportButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(exportButtonWidthScaleFactor)
            make.height.equalTo(exportButtonHeight)
            make.centerX.bottom.equalToSuperview()
        }
    }

    @objc func export() {
        delegate?.exportButtonCellButtonWasTapped()
    }

    func configure(for isExportable: Bool) {
        let titleColor: UIColor = isExportable ? .white : .clickerGrey2
        let backgroundColor: UIColor = isExportable ? .clickerGreen0 : .clear
        let borderColor: UIColor = isExportable ? .clickerGreen0 : UIColor.white.withAlphaComponent(0.9)
        exportButton.setTitleColor(titleColor, for: .normal)
        exportButton.backgroundColor = backgroundColor
        exportButton.layer.borderColor = borderColor.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
