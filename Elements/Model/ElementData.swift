//
//  File.swift
//  Elements
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct Element: Codable {
    
let name: String // needed
let appearance: String?
let atomicMass: Double //needed
let boil: Double? //needed
let category: String
let color: String?
let density: Double?
let discoveredBy: String? // needed
let melt: Double? // needed
let molarHeat: Double?
let namedBy: String?
let number: Int // needed
let period: Int
let source: String
let spectralImg: String?
let summary: String
let symbol: String // needed
let xpos: Int
let ypos: Int
let shells: [Int]

}
