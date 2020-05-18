//
//  HelpArticleInteractor.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation
import RxSwift

enum ServerStatus: Int, Error {
    case ok = 200
    case badRequest = 400
    case unauthorized = 403
    case notFound = 404
    case serverError = 500
}

protocol ArticleInteractorProtocol: class {
    func getArticleInfo(articleId: Int) -> Single<HelpArticle>
    func generateTicket(articleId: Int, clientMessage: String) -> Single<SupportTicket>
}

class ArticleInteractor: ArticleInteractorProtocol {
    
    func getArticleInfo(articleId: Int) -> Single<HelpArticle> {
        return Single<HelpArticle>.create(subscribe: { single in
            guard let url: URL = URL(string: "http://dummypath.com/article/\(articleId)") else {
                single(.error(ServerStatus.badRequest))
                return Disposables.create()
            }
            let urlRequest = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    single(.error(ServerStatus.serverError))
                    return
                }
                
                guard urlResponse.statusCode == 200 else {
                    single(.error(ServerStatus(rawValue: urlResponse.statusCode) ?? ServerStatus.serverError))
                    return
                }
                
                if let data = data, let article = try? JSONDecoder().decode(HelpArticle.self, from: data) {
                    single(.success(article))
                } else {
                    single(.error(ServerStatus.serverError))
                }
            }
            task.resume()
            return Disposables.create()
        })
    }
    
    func generateTicket(articleId: Int, clientMessage: String) -> Single<SupportTicket> {
        return Single<SupportTicket>.create(subscribe: { single in
            
            let params: [String: Any] = ["articleId": articleId,
                                         "message": clientMessage]
            guard let url: URL = URL(string: "http://dummypath.com/ticket/create"),
                  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) else {
                    
                single(.error(ServerStatus.badRequest))
                return Disposables.create()
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpBody = httpBody

            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    single(.error(ServerStatus.serverError))
                    return
                }
                
                guard urlResponse.statusCode == 200 else {
                    single(.error(ServerStatus(rawValue: urlResponse.statusCode) ?? ServerStatus.serverError))
                    return
                }
                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                if let data = data, let ticket = try? decoder.decode(SupportTicket.self, from: data) {
                    single(.success(ticket))
                } else {
                    single(.error(ServerStatus.serverError))
                }
            }
            
            task.resume()
            return Disposables.create()
        })
    }
    
}
