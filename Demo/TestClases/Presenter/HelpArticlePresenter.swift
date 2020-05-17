//
//  HelpArticlePresenter.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ArticlePresenter {
    func presentHelpArticle()
    func submitSupportTicket(clientMessage: String)
    func getArticleInfo() -> Observable<HelpArticle>
    func canSubmitMessage(with validMessage: Observable<String>) -> Observable<Bool>
}

class HelpArticlePresenter: ArticlePresenter {
    
    private let articleId: Int
    private let router: ArticleRouter
    private let interactor: ArticleInteractor
    private var disposeBag = DisposeBag()
    
    init(articleId: Int, router: ArticleRouter, interactor: ArticleInteractor) {
        self.articleId = articleId
        self.router = router
        self.interactor = interactor
    }
    
    func presentHelpArticle() {
        router.showArticle(with: self)
    }
    
    func submitSupportTicket(clientMessage: String) {
        interactor
            .generateTicket(articleId: articleId, clientMessage: clientMessage)
            .do(onError: {[weak self] error in
                self?.router.showError(with: error)
            })
            .asObservable()
            .subscribe(onNext: {[weak self] ticket in
                self?.router.showSuccessView()
            })
            .disposed(by: disposeBag)
    }
    
    func getArticleInfo() -> Observable<HelpArticle> {
        return interactor.getArticleInfo(articleId: articleId).asObservable()
    }
    
    func canSubmitMessage(with validMessage: Observable<String>) -> Observable<Bool> {
        return validMessage.map {
            $0.count > 10
            
        }.distinctUntilChanged()
    }
}
