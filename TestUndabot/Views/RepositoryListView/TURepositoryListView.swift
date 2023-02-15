//
//  TURepositoryListView.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit
import SnapKit

protocol TURepositoryListViewDelegate: AnyObject {
    func repositoryListView(_ listView: TURepositoryListView, didSelectUserWith url: String)
    func repositoryListView(_ listView: TURepositoryListView, didSelectRepositoryWith url: String)
}

/// A view holding a table view that presents cells with repository information, and UISearchController with it's ScopeButtons.
final class TURepositoryListView: UIView {
    private let viewModel = TURepositroyListViewViewModel()
    weak var delegate: TURepositoryListViewDelegate?

    public let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Repository name"
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Stars", "Forks", "Updated"]
        return searchController
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TURepositoryListTableViewCell.self,
                       forCellReuseIdentifier: TURepositoryListTableViewCell.identifier)
        table.keyboardDismissMode = .onDrag
        table.separatorStyle = .none
        return table
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        return spinner
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpViews() {
        addSubviews(tableView, spinner)
    }
    
    private func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
        
    private func configureView() {
        viewModel.delegate = self
        searchController.searchResultsUpdater = viewModel
        searchController.searchBar.delegate = viewModel
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}

// MARK: - TURepositroyListViewViewModelDelegate
extension TURepositoryListView: TURepositroyListViewViewModelDelegate {
    func openUserDetails(userUrl: String) {
        delegate?.repositoryListView(self, didSelectUserWith: userUrl)
    }
    
    func openRepositoryDetails(repositoryUrl: String) {
        delegate?.repositoryListView(self, didSelectRepositoryWith: repositoryUrl)
    }
    
    func beginLoadingRepositories() {
        spinner.startAnimating()
        tableView.backgroundView = nil
    }
    
    func failedToLoadSearchRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
        tableView.backgroundView = TUEmptyTableViewBackground()
    }

    func finishedLoadingOrSortingRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
    }
}
