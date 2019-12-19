//
//  ElementData.swift
//  Assessment Unit 3
//
//  Created by Jaheed Haynes on 12/19/19.
//  Copyright © 2019 Jaheed Haynes. All rights reserved.
//

import Foundation


//struct AllElements: Codable {
//    let results: [Element]
//}

struct Element: Codable {
    
let name: String // needed
let atomicMass: Double? //needed
let boil: Double? //needed
let discoveredBy: String? // needed
let melt: Double? // needed
let number: Int // needed
let symbol: String? // needed
let spectralImg: String? // needed
    
let favoritedBy: String? // extra credit
}
