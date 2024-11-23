//
//  ArticlesResponse.swift
//  News Application
//
//  Created by Assel Artykbay on 21.11.2024.
//

import Foundation

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
