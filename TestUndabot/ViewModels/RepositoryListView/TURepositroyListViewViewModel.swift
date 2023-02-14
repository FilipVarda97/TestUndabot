//
//  TURepositroyListViewViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

protocol TURepositroyListViewViewModelDelegate: AnyObject {
    func didLoadSearchRepositories()
    func beginLoadingRepositories()
    func failedToLoadSearchRepositories()
    func resetView()
    func openUserDetails(userUrl: String)
    func openRepositoryDetails(repositoryUrl: String)
}

/// A viewModel that fetches all repositories and searches for them using searchController. The viewModel is also responsible for sorting/filtering results.
final class TURepositroyListViewViewModel: NSObject {
    enum SortType {
        case stars
        case forks
        case updated
    }
    
    public weak var delegate: TURepositroyListViewViewModelDelegate?
    private var cellViewModels: [TURepositoryListTableViewCellViewModel] = []
    private var isLoadingSearchRepositories = false
    private var isInitalScreenPresented = true
    private var sortType: SortType = .stars
    
    private var repositories: [TURepository] = [] {
        didSet {
            cellViewModels.removeAll()
            for repository in repositories {
                let viewModel = TURepositoryListTableViewCellViewModel(repository: repository)
                cellViewModels.append(viewModel)
            }
        }
    }
        
    // MARK: - Implementation
    private func makeSearch(with name: String) {
        TURepositroyListViewViewModel.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(fetchRepositoriesWith(_:)), with: name, afterDelay: 0.5)
    }
    
    @objc private func fetchRepositoriesWith(_ name: String) {
        let queryParams = [
            URLQueryItem(name: "q", value: name)
        ]
        let tuRequest = TURequest(enpoint: .searchRepositories, queryParams: queryParams)
        if !isLoadingSearchRepositories {
            isLoadingSearchRepositories = true
            isInitalScreenPresented = false
            delegate?.beginLoadingRepositories()
            TUService.shared.execute(tuRequest, expected: TURepositoriesResponse.self) { [weak self] result in
                switch result {
                case .success(let response):
                    if response.totalCount == 0 {
                        self?.repositories.removeAll()
                        DispatchQueue.main.async {
                            self?.isLoadingSearchRepositories = false
                            self?.delegate?.failedToLoadSearchRepositories()
                        }
                    } else {
                        let repos = response.items
                        self?.repositories = repos
                        DispatchQueue.main.async {
                            self?.isLoadingSearchRepositories = false
                            self?.delegate?.didLoadSearchRepositories()
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.isLoadingSearchRepositories = false
                        self?.delegate?.failedToLoadSearchRepositories()
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TURepositroyListViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellViewModels.isEmpty && isInitalScreenPresented {
            tableView.backgroundView = TUEmptyRepositoryView(message: "Try searching for repo.")
            return 0
        }
        tableView.backgroundView = nil
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TURepositoryListTableViewCell.identifier) as? TURepositoryListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension TURepositroyListViewViewModel: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let name = searchController.searchBar.text, !name.isEmpty else { return }
        makeSearch(with: name)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isInitalScreenPresented = true
        repositories.removeAll()
        delegate?.resetView()
    }
}

extension TURepositroyListViewViewModel: TURepositoryListTableViewCellDelegate {
    func openUserDetailsWith(url: String) {
        delegate?.openUserDetails(userUrl: url)
    }

    func openRepositoryDetails(url: String) {
        delegate?.openRepositoryDetails(repositoryUrl: url)
    }
}
