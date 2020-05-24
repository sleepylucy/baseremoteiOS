//
//  PowerPack.swift
//  BaseRemote
//
//  Created by Lucy Prögler on 24.05.20.
//  Copyright © 2020 Lucy. All rights reserved.
//

import Foundation

struct PowerPacks: Codable {
    var oldBase: PowerPack
    var newBase: PowerPack?
    
    enum CodingKeys: String, CodingKey {
        case oldBase = "OldBase"
        case newBase = "NewBase"
    }
}

struct PowerPack: Codable {
    var capacity: Int
    var stored: Int
    var maintenance: Bool
}
