//
//  TUUserDetailsViewController.swift
//  TestUndabot
//
//  Created by Filip Varda on 14.02.2023..
//

import Foundation
import SnapKit

/// This controller presents TUUserDetailView and opens Safari.
final class TUUserDetailsViewController: UIViewController {
    private let userDetailsView: TUUserDetailView
    private let viewModel: TUUserDetailsViewModel

    // MARK: - Init
    init(viewModel: TUUserDetailsViewModel) {
        self.viewModel = viewModel
        self.userDetailsView = TUUserDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.userDetailsView.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User details"
        setUpViews()
    }

    private func setUpViews() {
        view.addSubview(userDetailsView)
        userDetailsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - TUUserDetailViewDelegate
extension TUUserDetailsViewController: TUUserDetailViewDelegate {
    func openUser(from view: TUUserDetailView, with userUrl: URL) {
        let alertController = UIAlertController(title: "Open in Safari",
                                                message: "Are you sure that you want to open this link in Safari?",
                                                preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "No", style: .cancel)
        let actionsYes = UIAlertAction(title: "YES", style: .default, handler: { _ in
            UIApplication.shared.open(userUrl)
        })
        alertController.addAction(actionsYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true)
    }
}
