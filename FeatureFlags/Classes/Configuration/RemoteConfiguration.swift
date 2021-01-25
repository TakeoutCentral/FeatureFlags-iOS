//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public protocol RemoteConfig {
    func value<T>(forKey key: String) -> T?
}

public class RemoteConfiguration: FeatureFlagsConfiguration {

    public let priority = 10

    private let remoteConfig: RemoteConfig

    public init(remoteConfig: RemoteConfig) {
        self.remoteConfig = remoteConfig
    }

    public func feature(named name: Feature.Name) -> Feature? {
        remoteConfig.value(forKey: name.rawValue)
    }
}
