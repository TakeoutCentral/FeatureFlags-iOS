//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public protocol FeatureFlagsConfiguration {
    var priority: Int { get }
    func feature(named name: Feature.Name) -> Feature?
}
