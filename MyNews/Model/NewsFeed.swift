//
//  NewsFeed.swift
//  MyNews
//
//  Created by IndratS on 02/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct NewsFeed: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author, title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
