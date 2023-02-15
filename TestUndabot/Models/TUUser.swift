//
//  TUUser.swift
//  TestUndabot
//
//  Created by Filip Varda on 14.02.2023..
//

import Foundation

struct TUUser: Codable {
    let name: String
    let avatarImageString: String
    let gitProfileUrl: String
    let bio: String
    let location: String
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarImageString = "avatar_url"
        case gitProfileUrl = "html_url"
        case bio, location
    }
}
