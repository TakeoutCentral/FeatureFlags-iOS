//
// Created by Mike on 1/25/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import FeatureFlags
import Foundation
import Reusable
import UIKit

internal protocol FeatureTableViewCell: UITableViewCell {
    var delegate: FeatureTableViewCellDelegate? { get set }
    var feature: Feature? { get set }
}

internal protocol FeatureTableViewCellDelegate {
    func featureTableViewCellDidChangeValue(_ cell: FeatureTableViewCell)
}

public final class FeaturesViewController: UITableViewController {

    fileprivate struct Section {
        let title: String
        let features: [Feature]
    }

    private var sections = [Section]()
    private var filteredSections = [Section]()

    private let searchController = UISearchController(searchResultsController: nil)

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Features"
        tableView.keyboardDismissMode = .onDrag

        setupBarButtonItems()
        if #available(iOS 11.0, *) {
            setupSearchController()
        }
    }
}

extension FeaturesViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        isFiltering() ? filteredSections.count : sections.count
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        featuresIn(section: section).count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feature = featureAt(indexPath: indexPath)!
        let cell: FeatureTableViewCell = tableView.dequeueReusableCell(
            for: indexPath,
            cellType: BooleanFeatureTableViewCell.self
        )
        cell.feature = feature
        cell.delegate = self
        return cell
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let thisSection = isFiltering() ? filteredSections[section] : sections[section]
        return thisSection.title
    }

    private func featuresIn(section: Int) -> [Feature] {
        let thisSection = isFiltering() ? filteredSections[section] : sections[section]
        return thisSection.features
    }

    fileprivate func featureAt(indexPath: IndexPath) -> Feature? {
        let features = featuresIn(section: indexPath.section)
        return features[indexPath.row]
    }
}

extension FeaturesViewController {
    private func setupBarButtonItems() {
        if isModal() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(dismissViewController)
            )
        }
    }

    @available(iOS 11.0, *)
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Features"
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func registerCellClasses() {
        tableView.register(cellType: BooleanFeatureTableViewCell.self)
    }

    private func rebuildSections() {
        guard let config = FeatureFlags.shared.configurations.first(where: { $0 is LocalConfiguration }),
              let localConfig = config as? LocalConfiguration
        else { return }

        sections = localConfig.features.map { section in
            let features = section.features.sorted { $0.displayName < $1.displayName }
            return Section(title: section.name, features: features)
        }
    }

    @objc
    private func dismissViewController() {
        view.endEditing(true)
        presentingViewController?.dismiss(animated: true)
    }

    private func isModal() -> Bool {
        presentingViewController != nil
    }
}

extension FeaturesViewController: FeatureTableViewCellDelegate {
    func featureTableViewCellDidChangeValue(_ cell: FeatureTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let feature = featureAt(indexPath: indexPath) {
                // TODO
            }
        }
    }
}

extension FeaturesViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
}

extension FeaturesViewController {
    private func searchBarIsEmpty() -> Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }

    private func filterContentFor(searchText text: String) {
        let searchText = text.lowercased()
        filteredSections = []
        for section in sections {
            var filteredFeatures = [Feature]()
            for feature in section.features {
                if feature.name.rawValue.lowercased().contains(searchText) ||
                    feature.displayName.lowercased().contains(searchText) ||
                    feature.description?.lowercased().contains(searchText) == true {
                    filteredFeatures.append(feature)
                }
            }
            if filteredFeatures.count > 0 {
                let filteredSection = Section(title: section.title, features: filteredFeatures)
                filteredSections.append(filteredSection)
            }
        }
        tableView.reloadData()
    }

    private func isFiltering() -> Bool {
        searchController.isActive && !searchBarIsEmpty()
    }
}
