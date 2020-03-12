//
//  Announcement.swift
//  AppDevAnnouncements
//
//  Created by Gonzalo Gonzalez on 10/16/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

public struct Announcement: Codable {

    /// The ID of the announcement
    let id: Int

    /// The main text of the notification
    let body: String

    /// The only action currently supported: visiting a URL
    let ctaAction: String

    /// The hex color of the CTA button
    let ctaButtonColor: String?

    /// The text on the call to action (CTA) button
    let ctaText: String

    /// The height of the image
    let imageHeight: Int?

    /// The URL of the image
    let imageUrl: String?

    /// The width of the image
    let imageWidth: Int?

    /// The header title of the notification
    let subject: String


}

internal struct Response<T: Codable>: Codable {

    let success: Bool

    let data: T
    
}
