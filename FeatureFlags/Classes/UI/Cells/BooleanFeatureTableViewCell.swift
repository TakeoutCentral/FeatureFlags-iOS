//
// Created by Mike on 1/25/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation
import Reusable

internal final class BooleanFeatureTableViewCell: UITableViewCell, FeatureTableViewCell, Reusable {

    var delegate: FeatureTableViewCellDelegate?

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var feature: Feature? {
        didSet {
            textLabel?.text = feature?.displayName
            detailTextLabel?.text = feature?.description
            switchControl.isOn = feature?.isEnabled() ?? false
        }
    }

    private lazy var switchControl: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(didChangeFeatureValue), for: .valueChanged)
        accessoryView = uiSwitch
        selectionStyle = .none
        return uiSwitch
    }()

    @objc
    private func didChangeFeatureValue() {
        delegate?.featureTableViewCellDidChangeValue(self)
    }
}
