//
//  TURepositoryDetailsViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//

import UIKit

protocol TURepositoryDetailsViewModelDelegate: AnyObject {
    func openRepositoryInBrowser(url: URL)
    func openUserDetails(with: URL)
}

/// ViewModel that builds colletion view's layout for presenting RepositoryDetails and opens a URL
/// in Safari, if provided with one. It can also open the UserDetails in another controller.
final class TURepositoryDetailsViewModel: NSObject {
    enum SectionType {
        case info(viewModels: [TURepositoryDetailInfoCollectionViewCellViewModel])
        case dates(viewModels: [TURepositoryDetailDatesCollectionViewCellViewModel])
        case user(viewModel: TURepositoryDetailUserCollectionViewCellViewModel)
        case url(viewModel: TURepositoryDetailUrlsCollectionViewCellViewModel)
    }
    public var sections: [SectionType] = []
    weak var delegate: TURepositoryDetailsViewModelDelegate?
    private var repository: TURepository?

    // MARK: - Init
    override init() {
        super.init()
        self.repository = nil
    }

    convenience init(repository: TURepository) {
        self.init()
        self.repository = repository
        setUpSections()
    }

    // MARK: - Implementation
    private func setUpSections() {
        guard let repository = repository else { return }
        sections = [
            .info(viewModels: [
                .init(type: .name, value: repository.name),
                .init(type: .authorName, value: repository.ownerUser.name),
                .init(type: .forksCount, value: String(repository.forksCount)),
                .init(type: .watchersCount, value: String(repository.watchersCount)),
                .init(type: .openIssuesCount, value: String(repository.openIssuesCount)),
                .init(type: .starsCount, value: String(repository.stargazersCount))
            ]),
            .dates(viewModels: [
                .init(type: .lastUpdated, dateString: repository.updatedAt),
                .init(type: .createdAt, dateString: repository.createdAt)
            ]),
            .user(viewModel: .init(ownerUser: repository.ownerUser)),
            .url(viewModel: .init(url: repository.repositoryUrl))
        ]
    }
}

// MARK: - LayoutSetUp
extension TURepositoryDetailsViewModel {
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

    public func createDatesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(200)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createUrlSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createUserSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
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
extension TURepositoryDetailsViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .url, .user:
            return 1
        case .dates(viewModels: let viewModels):
            return viewModels.count
        case .info(viewModels: let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .info(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TURepositoryDetailInfoCollectionViewCell.identifier,
                                                                for: indexPath) as? TURepositoryDetailInfoCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .dates(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TURepositoryDetailDatesCollectionViewCell.identifier,
                                                                for: indexPath) as? TURepositoryDetailDatesCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .url(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TURepositoryDetailUrlsCollectionViewCell.identifier,
                                                                for: indexPath) as? TURepositoryDetailUrlsCollectionViewCell else {
                fatalError("Ups, missing cell")
            }
            cell.configure(with: viewModel)
            return cell
        case .user(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TURepositoryDetailUserCollectionViewCell.identifier,
                                                                for: indexPath) as? TURepositoryDetailUserCollectionViewCell else {
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
        case .info, .dates:
            break
        case .url(let viewModel):
            guard let url = viewModel.urlToOpen else { return }
            delegate?.openRepositoryInBrowser(url: url)
        case .user(viewModel: let viewModel):
            guard let userUrl = viewModel.userUrl else { return }
            delegate?.openUserDetails(with: userUrl)
        }
    }
}
