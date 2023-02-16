//
//  TURepositoryDetailsViewController.swift
//  TestUndabot
//
//  Created by Filip Varda on 15.02.2023..
//

import Foundation
import SnapKit

/// This controller presents TURepositoryDetailsView, opens Safari or UserDetails.
final class TURepositoryDetailsViewController: UIViewController {
    private let viewModel: TURepositoryDetailsViewModel?
    private let repositoryDetailsView: TURepositoryDetailsView

    // MARK: - Init
    init(viewModel: TURepositoryDetailsViewModel) {
        self.viewModel = viewModel
        repositoryDetailsView = TURepositoryDetailsView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        repositoryDetailsView.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repository details"
        setUpViews()
    }

    private func setUpViews() {
        view.addSubview(repositoryDetailsView)
        repositoryDetailsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - TURepositoryDetailsViewDelegate
extension TURepositoryDetailsViewController: TURepositoryDetailsViewDelegate {
    func openUserDetails(from view: TURepositoryDetailsView, with userUrl: URL) {
        let viewModel = TUUserDetailsViewModel(userUrl: userUrl)
        let vc = TUUserDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func openRepository(from view: TURepositoryDetailsView, with repositoryUrl: URL) {
        let alertController = UIAlertController(title: "Open in Safari",
                                                message: "Are you sure that you want to open this link in Safari?",
                                                preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "No", style: .cancel)
        let actionsYes = UIAlertAction(title: "YES", style: .default, handler: { _ in
            UIApplication.shared.open(repositoryUrl)
        })
        alertController.addAction(actionsYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true)
    }
}
