//
//  Article.swift
//  AlamofireSample1
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import Foundation

/// 詳細情報を表示する
protocol Displayable {
    var titleLabelText: String { get }
    var subtitleLabelText: String { get }
    var item1: (label: String, value: String) { get }
    var item2: (label: String, value: String) { get }
    var item3: (label: String, value: String) { get }
    var listTitle: String { get }
    var listItems: [String] { get }
}

struct Film: Decodable {
    let id: Int
    let title: String
    let openigCrawl: String
    let director: String
    let producer: String
    let releaseDate: String
    let starships: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "episode_id"
        case title
        case openigCrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case starships
    }
}

extension Film: Displayable {
    var titleLabelText: String {
        title
    }
    
    var subtitleLabelText: String {
        "Episode \(id)"
    }
    
    var item1: (label: String, value: String) {
        ("DIRECTOR", director)
    }
    
    var item2: (label: String, value: String) {
        ("PRODUCER", producer)
    }
    
    var item3: (label: String, value: String) {
        ("RELEASE DATE", releaseDate)
    }
    
    var listTitle: String {
        "STARSHIPS"
    }
    
    var listItems: [String] {
        starships
    }
    
}
