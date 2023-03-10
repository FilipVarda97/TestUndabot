//
//  TURepositoryDetailUrlsCollectionViewCellViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//
// swiftlint:disable type_name

import Foundation

/// A viewModel responsible for managing data of TURepositoryDetailUrlsCollectionViewCell.
final class TURepositoryDetailUrlsCollectionViewCellViewModel {
    private var url: String

    // MARK: - Public Computed properties
    public var title: String {
        return "Open repository link"
    }
    public var urlToOpen: URL? {
        return URL(string: url)
    }

    // MARK: - Init
    init(url: String) {
        self.url = url
    }
}
