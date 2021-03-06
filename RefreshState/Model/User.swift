//
//  User.swift
//  RefreshState
//
//  Created by Павел Попов on 18.03.2020.
//  Copyright © 2020 Hamburger Studio. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: Int = 0
    var name: String?
    var url: String?
    var rating: Int?
    var status: String?
    var lastGame: Double?
}
