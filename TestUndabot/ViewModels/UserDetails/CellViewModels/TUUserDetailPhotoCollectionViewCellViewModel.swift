//
//  TUUserDetailPhotoCollectionViewCellViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//

import UIKit

/// A viewModel responsible for downloading an image of user's avatar.
final class TUUserDetailPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?
    
    // MARK: - Init
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    // MARK: - Implementation
    // NOTE: I understand that using KF would be simpler in this case. Most likely I would not need this viewModel and TUImageLoader at all.
    // But I wanted to show that this is possbile to achive without KF. I used KF in TURepositoryListTableViewCell.
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        TUImageLoader.shared.dowloadImage(url: imageUrl, completion: completion)
    }
}
