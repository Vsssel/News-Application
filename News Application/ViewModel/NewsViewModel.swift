//
//  NewsViewModel.swift
//  News Application
//
//  Created by Assel Artykbay on 22.11.2024.
//

import Foundation

class NewsViewModel {
    private(set) var articles: [Article] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchArticles() {
        NetworkService.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.onDataUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
                print(error)
            }
        }
    }
}

