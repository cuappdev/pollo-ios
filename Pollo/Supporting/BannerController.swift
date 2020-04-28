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
        banner.delegate = self
        self.currentBanner?.dismiss()
        self.currentBanner = banner
        self.currentBanner?.show(bannerPosition: .bottom)
    }

    func dismiss() {
        self.currentBanner?.dismiss()
        self.currentBanner = nil
    }
}

extension BannerController: NotificationBannerDelegate {

    public func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        if self.currentBanner == nil {
            banner.haptic = .none
            banner.isHidden = true
        }
    }

    public func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        if self.currentBanner == nil || banner != self.currentBanner {
            banner.dismiss()
        }
    }

    public func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) { }

    public func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) { }

}
