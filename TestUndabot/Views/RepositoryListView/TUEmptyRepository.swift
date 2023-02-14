//
//  TUEmptyRepository.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

final class TUEmptyRepositoryView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var message: String?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraints()
    }

    convenience init(message: String) {
        self.init()
        self.message = message
        setUpView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpView() {
        messageLabel.text = message
        addSubview(messageLabel)
    }

    private func setUpConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(40)
            make.left.right.equalToSuperview()
        }
    }
}
