//
//  MeSystem.swift
//  BaseRemote
//
//  Created by Lucy Prögler on 24.05.20.
//  Copyright © 2020 Lucy. All rights reserved.
//

import Foundation

struct MeSystems: Codable {
    var oldBase: MeSystem
    
    enum CodingKeys: String, CodingKey {
        case oldBase = "OldBase"
    }
}

struct MeSystem: Codable {
    var active: Bool
    var powerConsumption: Int
}
