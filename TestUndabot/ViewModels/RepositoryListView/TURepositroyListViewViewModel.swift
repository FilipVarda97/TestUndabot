//
//  TURepositroyListViewViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

final class TURepositroyListViewViewModel: NSObject {
    private let items = ["Joe", "Mama"]
}

extension TURepositroyListViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TURepositoryListTableViewCell.identifier) as? TURepositoryListTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
