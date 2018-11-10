//
//  EventPayload.swift
//  Clicker
//
//  Created by Kevin Chan on 10/25/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

/// Logging based on TCAT-ios

import Foundation

public protocol Payload: Codable {
    static var eventName: String {get}
}

public extension Payload {
    public func toEvent() -> Event<Self> {
        return Event(payload: self)
    }
}

/**Use JSONData for serialized JSON*/
public typealias JSONData = Data

public class Event<TPayload: Payload>: Codable {
    public let payload: TPayload
    public var eventName: String {return TPayload.eventName}

    init(payload: TPayload) {
        self.payload = payload
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = try values.decode(TPayload.self, forKey: .payload)
        let decodedEventName = try values.decode(String.self, forKey: .eventName)
        if decodedEventName != eventName {
            throw NSError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(self.payload, forKey: .payload)
        try values.encode(self.eventName, forKey: .eventName)
    }

    enum CodingKeys: String, CodingKey {
        case timestamp, payload, eventName = "event_type"
    }

    public func serializeJson() throws -> JSONData {
        return try JSONEncoder().encode(self)
    }
}
