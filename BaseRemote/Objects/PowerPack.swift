//
//  PowerPack.swift
//  BaseRemote
//
//  Created by Lucy Prögler on 24.05.20.
//  Copyright © 2020 Lucy. All rights reserved.
//

import Foundation

struct PowerPacks: Codable {
    var mountain: PowerPack?
    var tower: PowerPack?
    var chem: PowerPack?
    
    enum CodingKeys: String, CodingKey {
        case mountain = "OldBase"
        case tower = "NewBase"
        case chem = "Chem"
    }
}

struct PowerPack: Codable {
    var capacity: Int
    var stored: Int
    var maintenance: Bool
    var change: Int
}
