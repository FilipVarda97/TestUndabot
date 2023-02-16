//
//  TURepositoryDetailUserCollectionViewCellViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 16.02.2023..
//
// swiftlint:disable type_name

import UIKit

/// A viewModel responsible for managing data of TURepositoryDetailUserCollectionViewCell.
final class TURepositoryDetailUserCollectionViewCellViewModel: NSObject {
    private var ownerUser: TUOwnerUser

    // MARK: - Public Computed properties
    public var imageUrl: URL? {
        return URL(string: ownerUser.avatarImageString)
    }
    public var username: String {
        return ownerUser.name
    }
    public var userUrl: URL? {
        return URL(string: ownerUser.userUrl)
    }

    // MARK: - Init
    init(ownerUser: TUOwnerUser) {
        self.ownerUser = ownerUser
    }
}
