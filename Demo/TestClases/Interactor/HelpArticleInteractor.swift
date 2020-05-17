//
//  HelpArticleInteractor.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation
import RxSwift

protocol ArticleInteractor {
    func getArticleInfo(articleId: Int) -> Single<HelpArticle>
    func generateTicket(articleId: Int, clientMessage: String) -> Single<SupportTicket>
}
