//
//  Network.swift
//  News Application
//
//  Created by Assel Artykbay on 21.11.2024.
//

import Alamofire

class NetworkService {
    static let shared = NetworkService()
    private let apiKey = "6f965f6fc69c49ccac544eaf7de78225"
    private init() {}
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines"
        let params = ["country": "us", "apiKey": apiKey]
        
        AF.request(url, parameters: params).responseDecodable(of: ArticlesResponse.self) { response in
            switch response.result {
            case .success(let articlesResponse):
                completion(.success(articlesResponse.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
