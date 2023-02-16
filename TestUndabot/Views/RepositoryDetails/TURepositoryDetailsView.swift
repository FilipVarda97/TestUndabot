//
//  TURepositoryDetailsView.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//

import UIKit
import SnapKit

protocol TURepositoryDetailsViewDelegate: AnyObject {
    func openRepository(from view: TURepositoryDetailsView, with repositoryUrl: URL)
    func openUserDetails(from view: TURepositoryDetailsView, with userUrl: URL)
}

/// A view that presents details about selected repository.
/// Holds UICollectionView with custom CompositionalLayout.
final class TURepositoryDetailsView: UIView {
    weak var delegate: TURepositoryDetailsViewDelegate?
    private var viewModel: TURepositoryDetailsViewModel

    private var collectionView: UICollectionView?

    // MARK: - Init
    init(frame: CGRect, viewModel: TURepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.delegate = self
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpViews() {
        collectionView = createColletionView()
        guard let collectionView = collectionView else {
            return
        }
        addSubviews(collectionView)
    }

    private func setUpConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func createColletionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TURepositoryDetailInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: TURepositoryDetailInfoCollectionViewCell.identifier)
        collectionView.register(TURepositoryDetailDatesCollectionViewCell.self,
                                forCellWithReuseIdentifier: TURepositoryDetailDatesCollectionViewCell.identifier)
        collectionView.register(TURepositoryDetailUrlsCollectionViewCell.self,
                                forCellWithReuseIdentifier: TURepositoryDetailUrlsCollectionViewCell.identifier)
        collectionView.register(TURepositoryDetailUserCollectionViewCell.self,
                                forCellWithReuseIdentifier: TURepositoryDetailUserCollectionViewCell.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .info:
            return viewModel.createInfoSection()
        case .dates:
            return viewModel.createDatesSection()
        case .url:
            return viewModel.createUrlSection()
        case .user:
            return viewModel.createUserSection()
        }
    }
}

// MARK: - TURepositoryDetailsViewModelDelegate
extension TURepositoryDetailsView: TURepositoryDetailsViewModelDelegate {
    func openUserDetails(with url: URL) {
        delegate?.openUserDetails(from: self, with: url)
    }

    func openRepositoryInBrowser(url: URL) {
        delegate?.openRepository(from: self, with: url)
    }
}
