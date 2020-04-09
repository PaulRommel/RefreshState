//
//  Rating.swift
//  RefreshState
//
//  Created by Павел Попов on 02.04.2020.
//  Copyright © 2020 Hamburger Studio. All rights reserved.
//

import Foundation

struct Rating: Decodable {
    var userId: Int?
    var rating: Int?
    var status: String?
    var lastGame: Double?
}
