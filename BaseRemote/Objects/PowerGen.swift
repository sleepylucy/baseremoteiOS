//
//  PowerGen.swift
//  BaseRemote
//
//  Created by Lucy Prögler on 24.05.20.
//  Copyright © 2020 Lucy. All rights reserved.
//

import Foundation

struct PowerGen: Codable {
    var type: PowerGenType = .hydro
    var production: Int = 0
}

enum PowerGenType: String, Codable {
    case hydro = "Hydro"
    case wind = "Wind"
    case solar = "Solar"
}
