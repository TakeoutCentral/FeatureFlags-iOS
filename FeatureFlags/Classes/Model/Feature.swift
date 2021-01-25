//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public struct Feature {
    public let name: Name
    public let displayName: String
    public let description: String?
    public let type: FeatureType
    public var parent: Feature? {
        guard let name = _parentName else { return nil }
        return Feature.named(name)
    }

    // swiftlint:disable identifier_name
    internal var _enabled: Bool
    internal var _unlocked: Bool?
    internal var _parentName: Name?
    internal var _value: Value?
    // swiftlint:enable identifier_name

    public static func named(_ name: Feature.Name) -> Feature {
        FeatureFlags.shared.feature(named: name)
    }

    public static func isEnabled(_ feature: Feature.Name) -> Bool {
        named(feature).isEnabled()
    }

    public static func isUnlocked(_ feature: Feature.Name) -> Bool {
        named(feature).isUnlocked()
    }

    public static func value(for feature: Feature.Name) -> Value? {
        named(feature).value()
    }

    public func isEnabled() -> Bool {
        _enabled && parent?.isEnabled() == true
    }

    public func isUnlocked() -> Bool {
        guard let unlocked = _unlocked else { return false }
        return isEnabled() && type == .unlockFlag && unlocked
    }

    public func value() -> Value? {
        guard let value = _value
        else {
            preconditionFailure("Feature \(name) does not have an associated value")
        }
        return isEnabled() ? value : nil
    }

    internal mutating func setUnlocked(_ unlocked: Bool = true) {
        _unlocked = unlocked
    }

    @discardableResult
    public mutating func lock() -> Bool {
        setUnlocked(false)
        return !isUnlocked()
    }

    @discardableResult
    public mutating func unlock() -> Bool {
        setUnlocked(true)
        return isUnlocked()
    }
}

extension Feature {
    public struct Value: Codable {
    }
}
