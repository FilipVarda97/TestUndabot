//
//  TUSearchRepoListViewController.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit
import SnapKit

/// Initial controller for the app. This controller presents list of repositories and has the ability to search for repositories with provided name.
final class TUSearchRepoListViewController: UIViewController {
    private let repoListView = TURepositoryListView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        setUpViews()
    }
    
    private func setUpViews() {
        repoListView.delegate = self
        navigationItem.searchController = repoListView.searchController
        view.addSubview(repoListView)
        repoListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension TUSearchRepoListViewController: TURepositoryListViewDelegate {
    func repositoryListView(_ listView: TURepositoryListView, didSelectUserWith url: String) {
        print(url)
        // TODO: Open user details
    }
    
    func repositoryListView(_ listView: TURepositoryListView, didSelectRepositoryWith url: String) {
        print(url)
        // TODO: Open repo details
    }
}
