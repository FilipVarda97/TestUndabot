//
//  TURepositroyListViewViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

protocol TURepositroyListViewViewModelDelegate: AnyObject {
    func beginLoadingRepositories()
    func failedToLoadSearchRepositories()
    func finishedLoadingOrSortingRepositories()
    func openUserDetails(userUrl: URL)
    func openRepositoryDetails(repository: TURepository)
}

/// A viewModel that fetches all repositories and searches for them using searchController.
/// The viewModel is also responsible for sorting/filtering results based on selected index of ScopeButton.
final class TURepositroyListViewViewModel: NSObject {
    private var isLoadingSearchRepositories = false
    private var shouldInitialScreenPresent = true

    public weak var delegate: TURepositroyListViewViewModelDelegate?
    private var cellViewModels: [TURepositoryListTableViewCellViewModel] = []

    enum SortType {
        case stars
        case forks
        case updated
    }

    private var sortType: SortType = .stars {
        didSet {
            sortRepositories()
        }
    }

    private var repositories: [TURepository] = [] {
        didSet {
            sortRepositories()
        }
    }

    private var sortedRepositories: [TURepository] = [] {
        didSet {
            cellViewModels.removeAll()
            for repository in sortedRepositories {
                let viewModel = TURepositoryListTableViewCellViewModel(repository: repository)
                cellViewModels.append(viewModel)
            }
        }
    }

    // MARK: - Implementation
    private func fetchRepositories(with name: String) {
        let queryParams = [
            URLQueryItem(name: "q", value: name)
        ]
        let tuRequest = TURequest(enpoint: .searchRepositories, queryParams: queryParams)
        if !isLoadingSearchRepositories {
            delegate?.beginLoadingRepositories()
            isLoadingSearchRepositories = true
            shouldInitialScreenPresent = false
            TUService.shared.execute(tuRequest, expected: TURepositoriesResponse.self) { [weak self] result in
                self?.isLoadingSearchRepositories = false
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.totalCount > 0 {
                            self?.repositories = response.items
                        } else {
                            self?.repositories.removeAll()
                            self?.delegate?.failedToLoadSearchRepositories()
                        }
                    case .failure:
                        self?.delegate?.failedToLoadSearchRepositories()
                    }
                }
            }
        }
    }

    private func sortRepositories() {
        switch sortType {
        case .stars:
            sortedRepositories = repositories.sorted(by: { $0.stargazersCount > $1.stargazersCount })
        case .forks:
            sortedRepositories = repositories.sorted(by: { $0.forksCount > $1.forksCount })
        case .updated:
            let dateFormatter = ISO8601DateFormatter()
            sortedRepositories = repositories.sorted {
                guard let firstDate = dateFormatter.date(from: $0.updatedAt),
                      let secondDate = dateFormatter.date(from: $1.updatedAt) else {
                    return false
                }
                return firstDate > secondDate
            }
            // MARK: [TEST] - Uncomment to print sorted array of dates since "TURepository.updatedAt" is not preseneted on UI.
            // print(sortedRepositories.compactMap { return $0.updatedAt })
        }
        delegate?.finishedLoadingOrSortingRepositories()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TURepositroyListViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellViewModels.isEmpty && shouldInitialScreenPresent {
            tableView.backgroundView = TUEmptyTableViewBackground(message: "Try searching for repo.")
            return 0
        }
        tableView.backgroundView = nil
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TURepositoryListTableViewCell.identifier) as? TURepositoryListTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension TURepositroyListViewViewModel: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let name = searchBar.text, !name.isEmpty else { return }
        fetchRepositories(with: name)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldInitialScreenPresent = true
        repositories.removeAll()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            sortType = .stars
        case 1:
            sortType = .forks
        case 2:
            sortType = .updated
        default:
            break
        }
    }
}

// MARK: - TURepositoryListTableViewCellDelegate
extension TURepositroyListViewViewModel: TURepositoryListTableViewCellDelegate {
    func openUserDetailsWith(url: URL) {
        delegate?.openUserDetails(userUrl: url)
    }

    func openRepositoryDetails(repository: TURepository) {
        delegate?.openRepositoryDetails(repository: repository)
    }
}
