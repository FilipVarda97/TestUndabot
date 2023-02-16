//
//  TUUserDetailView.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//

import UIKit
import SnapKit

protocol TUUserDetailViewDelegate: AnyObject {
    func openUser(from view: TUUserDetailView, with userUrl: URL)
}

/// A view that presents details about selected user.
/// Holds UICollectionView with custom CompositionalLayout.
final class TUUserDetailView: UIView {
    weak var delegate: TUUserDetailViewDelegate?
    private var viewModel: TUUserDetailsViewModel

    private var collectionView: UICollectionView?
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Init
    init(frame: CGRect, viewModel: TUUserDetailsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.viewModel.delegate = self
        collectionView = createColletionView()
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpViews() {
        guard let collectionView = collectionView else {
            return
        }
        addSubviews(collectionView, spinner)
    }

    private func setUpConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalTo(self)
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
        collectionView.register(TUUserDetailPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUUserDetailPhotoCollectionViewCell.identifier)
        collectionView.register(TUUserDetailsInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUUserDetailsInfoCollectionViewCell.identifier)
        collectionView.register(TUUserDetailsGitCollectionViewCell.self,
                                forCellWithReuseIdentifier: TUUserDetailsGitCollectionViewCell.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }

    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch viewModel.sections[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSection()
        case .information:
            return viewModel.createInfoSection()
        case .userGitUrl:
            return viewModel.createGitSection()
        }
    }
}

// MARK: - TUUserDetailsViewModelDelegate
extension TUUserDetailView: TUUserDetailsViewModelDelegate {
    func startLoading() {
        collectionView?.backgroundView = nil
        spinner.startAnimating()
    }

    func didLoadUser() {
        spinner.stopAnimating()
        collectionView?.backgroundView = nil
        collectionView?.isHidden = false
        collectionView?.reloadData()
    }

    func failedToLoadUser() {
        spinner.stopAnimating()
        collectionView?.isHidden = false
        collectionView?.reloadData()
        collectionView?.backgroundView = TUEmptyTableViewBackground(message: "Could not load user :/")
    }

    func openUserInBrowser(url: URL) {
        delegate?.openUser(from: self, with: url)
    }
}
