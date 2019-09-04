//
//  DraftsTitleSectionController.swift
//  Pollo
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class DraftsTitleSectionController: ListSectionController {

    // MARK: - Data vars
    var draftsTitleModel: DraftsTitleModel!

    // MARK: - Constants
    let cellHeight: CGFloat = 60

    // MARK: - Override
    override func sizeForItem(at index: Int) -> CGSize { guard let containerSize = collectionContext?.containerSize else {
        return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: DraftsTitleCell.self, for: self, at: index) as! DraftsTitleCell
        cell.configure(with: draftsTitleModel)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.draftsTitleModel = object as? DraftsTitleModel
    }

    // MARK: - Public
    func shouldLightenText(_ shouldLighten: Bool) {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? DraftsTitleCell else { return }
        cell.shouldLightenText(shouldLighten)
    }

}
