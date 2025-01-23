//
//  NewsModel.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 02/12/23.
//

import Foundation


// MARK: - NewsModel
struct NewsModel: Codable {
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
