//
//  TUEndpoint.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import Foundation

///Enpoints for TURequest. Return string coresponding to enpoint
enum TUEndpoint: String {
    case initialRepositorySearch = "search/repositories?q=A"
    case repositories = "search/repositories"
    case users
}
