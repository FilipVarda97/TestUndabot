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

/// A view holding a table view that presents cells with repo info.
final class TURepositoryListView: UIView {
    private let viewModel = TURepositroyListViewViewModel()
    public let sortButton = UIBarButtonItem()
    weak var delegate: TURepositoryListViewDelegate?
    
    public let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Repository name"
        return searchController
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TURepositoryListTableViewCell.self,
                       forCellReuseIdentifier: TURepositoryListTableViewCell.identifier)
        table.keyboardDismissMode = .onDrag
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
        setUpView()
        setUpConstraints()
        setUpTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpView() {
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
        
    private func setUpTableView() {
        viewModel.delegate = self
        searchController.searchResultsUpdater = viewModel
        searchController.searchBar.delegate = viewModel
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}

// MARK: - TURepositroyListViewViewModelDelegate
extension TURepositoryListView: TURepositroyListViewViewModelDelegate {
    func beginLoadingRepositories() {
        spinner.startAnimating()
        tableView.backgroundView = nil
    }

    func didLoadSearchRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 1
        }
    }
    
    func failedToLoadSearchRepositories() {
        spinner.stopAnimating()
        tableView.reloadData()
        tableView.backgroundView = TUEmptyRepositoryView(message: "Something went wrong. Make sure the naming is correct.")
    }
    
    func resetView() {
        spinner.stopAnimating()
        tableView.reloadData()
    }

    func openUserDetails(userUrl: String) {
        delegate?.repositoryListView(self, didSelectUserWith: userUrl)
    }
    
    func openRepositoryDetails(repositoryUrl: String) {
        delegate?.repositoryListView(self, didSelectRepositoryWith: repositoryUrl)
    }
}
