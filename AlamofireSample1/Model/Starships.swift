//
//  Starships.swift
//  AlamofireSample1
//
//  Created by 鈴木楓香 on 2023/02/11.
//

import Foundation

struct Starships: Decodable {
    var count: Int
    var all: [Starship]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}
