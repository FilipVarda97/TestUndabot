//
//  TUSearchRepoListViewController.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

/// Initial controller for the app. This controller presents list of repositories and has the ability to search for repositories with provided name.
final class TUSearchRepoListViewController: UIViewController {
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        setUpViews()
    }
    
    private func setUpViews() {
        navigationItem.searchController = searchController
    }
}

