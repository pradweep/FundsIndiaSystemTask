//
//  GHRepoModel.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit

struct GHRepoModel: Decodable {
    var id: Int?
    var name: String?
    var full_name: String?
    var owner: Owner?
    var description: String?
}

struct Owner: Decodable {
    var login: String?
    var avatar_url: String?
}
