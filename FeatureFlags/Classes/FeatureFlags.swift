//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public class FeatureFlags {
    public static let shared = FeatureFlags()
    private init() {}

    private(set) var configurations = [FeatureFlagsConfiguration]()
//    var mutableConfiguration:
    public var useCache = false {
        didSet {
            if useCache != oldValue {
                resetCache()
            }
        }
    }

    private let queue = DispatchQueue(label: "takeoutcentral.featureflags")
    private var cache = [String : Feature]()

    public func add(configuration: FeatureFlagsConfiguration) {
        configurations.append(configuration)
        configurations.sort { $0.priority > $1.priority }
    }

    public func feature(named name: Feature.Name) -> Feature {
        queue.sync {
            if useCache, let feature = cache[name.rawValue] {
                return feature
            }

            for configuration in configurations {
                if let feature = configuration.feature(named: name) {
                    if useCache {
                        cache[name.rawValue] = feature
                    }
                    return feature
                }
            }

            preconditionFailure("Feature \(name) not initialized")
        }
    }
}

extension FeatureFlags {
    public func resetCache() {
        queue.sync {
            cache = [:]
        }
    }
}
