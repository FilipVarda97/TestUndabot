//
//  TUUserDetailsViewController.swift
//  TestUndabot
//
//  Created by Filip Varda on 14.02.2023..
//

import Foundation
import SnapKit

final class TUUserDetailsViewController: UIViewController {
    private let viewModel: TUUserDetailsViewModel?
    
    init(viewModel: TUUserDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}
