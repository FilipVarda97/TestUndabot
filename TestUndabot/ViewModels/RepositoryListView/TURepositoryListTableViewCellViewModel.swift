//
//  TURepositoryListTableViewCellViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import Foundation

final class TURepositoryListTableViewCellViewModel {
    private let repository: TURepository

    // MARK: - Public calculated properties
    public var id: Int {
        return repository.id
    }
    public var avatarURL: URL? {
        return URL(string: repository.ownerUser.avatarImageString)
    }
    public var repositoryTitle: String {
        return repository.name
    }
    public var authorName: String {
        return repository.ownerUser.name
    }
    public var userUrl: String {
        return repository.ownerUser.userUrl
    }
    public var repositoryUrl: String {
        return repository.repositoryUrl
    }
    public var starsCountText: String {
        return "Stars: \(repository.stargazersCount)"
    }
    public var watchersCountText: String {
        return "Watchers: \(repository.watchersCount)"
    }
    public var forksCountText: String {
        return "Forks: \(repository.forksCount)"
    }
    public var issuesCountText: String {
        return "Open issues: \(repository.openIssuesCount)"
    }

    // MARK: - Init
    init(repository: TURepository) {
        self.repository = repository
    }
}
