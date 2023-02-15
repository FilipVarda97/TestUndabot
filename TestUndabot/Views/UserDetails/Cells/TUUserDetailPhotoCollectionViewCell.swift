//
//  TUUserDetailPhotoCollectionViewCell.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//

import UIKit
import SnapKit

/// A cell for TUUserDetailView. Hold the user avatar image.
final class TUUserDetailPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "TUUserDetailPhotoCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }

    private func setUpViews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        containerView.clipsToBounds = true

        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
    }

    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(containerView.snp.height)
        }
        avatarImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalToSuperview().inset(10)
            make.width.equalTo(avatarImageView.snp.height)
        }
    }

    private func setUpLayer() {
        containerView.layer.cornerRadius = containerView.frame.height / 2
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -8, height: 8)
        contentView.layer.shadowOpacity = 0.3
    }

    public func configure(with viewModel: TUUserDetailPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.avatarImageView.image = UIImage(data: data)
                    self?.setUpLayer()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
