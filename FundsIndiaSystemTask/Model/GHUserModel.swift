//
//  GHUserModel.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 13/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import Foundation

struct GHUserModel: Decodable {
    var public_repos: Int?
    var location: String?
    var bio: String?
    var followers: Int?
    var following: Int?
    var avatar_url: String?
}
