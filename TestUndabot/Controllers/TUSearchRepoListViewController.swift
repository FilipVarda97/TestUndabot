//
//  TUSearchRepoListViewController.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit
import SnapKit

/// Initial controller for the app. This controller presents TURepositoryListView which supports searching for repos and sorting them.
final class TUSearchRepoListViewController: UIViewController {
    private let repoListView = TURepositoryListView(frame: .zero)

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        setUpViews()
    }

    private func setUpViews() {
        repoListView.delegate = self
        navigationItem.searchController = repoListView.searchController
        view.backgroundColor = .systemBackground
        view.addSubview(repoListView)
        repoListView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - TURepositoryListViewDelegate
extension TUSearchRepoListViewController: TURepositoryListViewDelegate {
    func repositoryListView(_ listView: TURepositoryListView, didSelectUserWith url: URL) {
        let viewModel = TUUserDetailsViewModel(userUrl: url)
        let vc = TUUserDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func repositoryListView(_ listView: TURepositoryListView, didSelectRepository repository: TURepository) {
        let viewModel = TURepositoryDetailsViewModel(repository: repository)
        let vc = TURepositoryDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
