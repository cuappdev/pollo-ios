//
//  BannerController.swift
//  Pollo
//
//  Created by Jack Thompson on 2/7/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import Foundation
import NotificationBannerSwift

public class BannerController {

    static let shared = BannerController()

    var currentBanner: BaseNotificationBanner?

    func show(_ banner: BaseNotificationBanner) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentBanner?.dismiss()
            self.currentBanner = banner
            self.currentBanner?.show(bannerPosition: .bottom)
        }
    }

    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentBanner?.dismiss()
            self.currentBanner = nil
        }
    }
}
