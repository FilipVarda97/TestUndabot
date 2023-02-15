//
//  TUUserDetailsViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 14.02.2023..
//

import UIKit

protocol TUUserDetailsViewModelDelegate: AnyObject {
    func startLoading()
    func didLoadUser()
    func failedToLoadUser()
    func openUserInBrowser(url: URL)
}

/// ViewModel that builds colletion view's layout and opens a WebView fir the provided user URL.
final class TUUserDetailsViewModel: NSObject {
    enum SectionType {
        case photo(viewModel: TUUserDetailPhotoCollectionViewCellViewModel)
        case information(viewModels: [TUUserDetailsInfoCollectionViewCellViewModel])
        case userGitUrl(viewModel: TUUserDetailsGitCollectionViewCellViewModel)
    }

    weak var delegate: TUUserDetailsViewModelDelegate?
    public var sections: [SectionType] = []
    private var userUrl: String?

    private var user: TUUser? {
        didSet {
            setUpSections()
        }
    }

    // MARK: - Init
    override init() {
        super.init()
        self.userUrl = nil
    }

    convenience init(userUrl: String) {
        self.init()
        self.userUrl = userUrl
        fetchUser()
    }

    // MARK: - Implementation
    private func fetchUser() {
        guard let urlString = userUrl,
            let url = URL(string: urlString),
            let tuRequest = TURequest(url: url) else { return }
        delegate?.startLoading()
        TUService.shared.execute(tuRequest, expected: TUUser.self) { [weak self] result  in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user
                    self?.delegate?.didLoadUser()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.delegate?.failedToLoadUser()
                }
            }
        }
    }

    private func setUpSections() {
        guard let user = user else { return }
        sections = [
            .photo(viewModel: TUUserDetailPhotoCollectionViewCellViewModel(imageUrl: URL(string: user.avatarImageString))),
            .information(viewModels: [
                .init(type: .name, value: user.name ?? ""),
                .init(type: .bio, value: user.bio ?? ""),
                .init(type: .login, value: user.login),
                .init(type: .location, value: user.location ?? ""),
                .init(type: .followers, value: String(user.followers)),
                .init(type: .id, value: String(user.id))
            ]),
            .userGitUrl(viewModel: .init(url: user.gitProfileUrl))
        ]
    }
}

// MARK: - LayoutSetUp
extension TUUserDetailsViewModel {
    public func createPhotoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.4)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createInfoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createGitSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TUUserDetailsViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photo, .userGitUrl:
            return 1
        case .information(viewModels: let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .photo(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TUUserDetailPhotoCollectionViewCell.identifier,
                                                                for: indexPath) as? TUUserDetailPhotoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModel)
            return cell
        case .information(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TUUserDetailsInfoCollectionViewCell.identifier,
                                                                for: indexPath) as? TUUserDetailsInfoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .userGitUrl(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TUUserDetailsGitCollectionViewCell.identifier,
                                                                for: indexPath) as? TUUserDetailsGitCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .userGitUrl(let viewModel):
            guard let url = viewModel.urlToOpen else { return }
            delegate?.openUserInBrowser(url: url)
        }
    }
}
