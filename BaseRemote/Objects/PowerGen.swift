//
//  PowerGen.swift
//  BaseRemote
//
//  Created by Lucy Prögler on 24.05.20.
//  Copyright © 2020 Lucy. All rights reserved.
//

import Foundation

struct PowerGens: Codable {
    var dam11: PowerGen?
    var dam12: PowerGen?
    var dam13: PowerGen?
    var dam14: PowerGen?
    var dam15: PowerGen?
    var dam16: PowerGen?
    var dam17: PowerGen?
    
    var dam21: PowerGen?
    var dam22: PowerGen?
    var dam23: PowerGen?
    var dam24: PowerGen?
    var dam25: PowerGen?
    var dam26: PowerGen?
    var dam27: PowerGen?
    
    var chemN1: PowerGen?
    var chemN2: PowerGen?
    var chemE1: PowerGen?
    var chemE2: PowerGen?
    var chemS1: PowerGen?
    var chemS2: PowerGen?
    var chemW1: PowerGen?
    var chemW2: PowerGen?
    
    var mountainWind: PowerGen?
    
    enum CodingKeys: String, CodingKey {
        case dam11 = "Dam11"
        case dam12 = "Dam12"
        case dam13 = "Dam13"
        case dam14 = "Dam14"
        case dam15 = "Dam15"
        case dam16 = "Dam16"
        case dam17 = "Dam17"
        
        case dam21 = "Dam21"
        case dam22 = "Dam22"
        case dam23 = "Dam23"
        case dam24 = "Dam24"
        case dam25 = "Dam25"
        case dam26 = "Dam26"
        case dam27 = "Dam27"
        
        case chemN1 = "ChemN1"
        case chemN2 = "ChemN2"
        case chemE1 = "ChemE1"
        case chemE2 = "ChemE2"
        case chemS1 = "ChemS1"
        case chemS2 = "ChemS2"
        case chemW1 = "ChemW1"
        case chemW2 = "ChemW2"
        
        case mountainWind = "MountainWind"
    }
    
    func getDamGens() -> [PowerGenLocation: PowerGen?] {
        return [.dam11: dam11, .dam12: dam12, .dam13: dam13, .dam14: dam14, .dam15: dam15, .dam16: dam16, .dam17: dam17,
                .dam21: dam21, .dam22: dam22, .dam23: dam23, .dam24: dam24, .dam25: dam25, .dam26: dam26, .dam27: dam27]
    }
    
    func getChemGens() -> [PowerGenLocation: PowerGen?] {
        return [.chemN1: chemN1, .chemN2: chemN2, .chemS1: chemS1, .chemS2: chemS2,
                .chemE1: chemE1, .chemE2: chemE2, .chemW1: chemW1, .chemW2: chemW2]
    }
}

struct PowerGen: Codable {
    var type: PowerGenType = .hydro
    var production: Int = 0
}

enum PowerGenType: String, Codable {
    case hydro = "Hydro"
    case wind = "Wind"
    case solar = "Solar"
}

enum PowerGenLocation {
    case dam11, dam12, dam13, dam14, dam15, dam16, dam17
    case dam21, dam22, dam23, dam24, dam25, dam26, dam27

    case chemN1, chemN2, chemE1, chemE2, chemS1, chemS2, chemW1, chemW2
    
    case mountainWind
}
