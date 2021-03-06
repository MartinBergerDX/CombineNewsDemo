//
//  Story.swift
//  NewsApp
//
//  Created by Martin on 6/9/20.
//  Copyright © 2020 HeavyDebugging.inc. All rights reserved.
//

import Foundation

public struct Story: Codable, Identifiable {
    public typealias ID = Int
    public let id: Int
    public let title: String
    public let by: String
    public let time: TimeInterval
    public let url: String
}

extension Story: Comparable {
    public static func < (lhs: Story, rhs: Story) -> Bool {
        return lhs.time > rhs.time
    }
}

extension Story: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\n\(title)\nby \(by)\n\(url)\n-----"
    }
}
