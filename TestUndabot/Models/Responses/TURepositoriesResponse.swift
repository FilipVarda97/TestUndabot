//
//  TURepositoriesResponse.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import Foundation

struct TURepositoriesResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [TURepository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

