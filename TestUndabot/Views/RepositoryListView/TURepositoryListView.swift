//
//  TURepositoryListView.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

/// A view holding a table view that presents cells with repo info.
final class TURepositoryListView: UIView {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TURepositoryListTableViewCell.self,
                       forCellReuseIdentifier: TURepositoryListTableViewCell.identifier)
        return table
    }()

    private let viewModel = TURepositroyListViewViewModel()

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
        backgroundColor = .systemGray5
        addSubview(tableView)
    }
    
    private func setUpConstraints() {}
        
    private func setUpTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}
