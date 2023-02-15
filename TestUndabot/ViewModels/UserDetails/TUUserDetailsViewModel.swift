//
//  TUUserDetailsViewModel.swift
//  TestUndabot
//
//  Created by Filip Varda on 14.02.2023..
//

import Foundation

final class TUUserDetailsViewModel: NSObject {
    private var userUrl: String?
    
    override init() {
        super.init()
        self.userUrl = nil
        setUpSections()
    }

    convenience init(userUrl: String) {
        self.init()
        self.userUrl = userUrl
        setUpSections()
    }

    private func setUpSections() {
        
    }
}
