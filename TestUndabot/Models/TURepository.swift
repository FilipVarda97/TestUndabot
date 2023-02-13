//
//  TURepository.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import Foundation

struct TURepository: Codable {
    let id: Int
    let name: String
    let isPrivate: Bool
    let ownerUser: TUOwnerUser
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case isPrivate = "private"
        case ownerUser = "owner"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}