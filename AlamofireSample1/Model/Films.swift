//
//  Films.swift
//  AlamofireSample1
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import Foundation

struct Films: Decodable {
    let count: Int
    let all: [Film]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}
