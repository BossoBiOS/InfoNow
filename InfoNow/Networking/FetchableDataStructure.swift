//
//  FetchableDataStructure.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import Foundation
import UIKit

struct Articles: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
    let message: String?
}

struct Article: Codable, Identifiable, Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == lhs.id
    }
    
    var id: String {title ?? UUID().uuidString}
    
    let source: Source
    let author: String?
    let title: String?
    let description: String
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
