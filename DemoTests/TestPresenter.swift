//
//  TestPresenter.swift
//  DemoTestTests
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import Demo

class TestPresenter: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    private typealias SUT = (presenter: HelpArticlePresenter, router: RouterSpy)

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        
    }
    
    func test_presenter_showArticle() {
        let sut = makeSUT()
        
        sut.presenter.presentHelpArticle()
        
        XCTAssertEqual(sut.router.didShowView, true)
    }
    
    func test_presenter_deliverArticle() {
        let sut = makeSUT()
        
        var receivedArticle: HelpArticle?
        
        sut.presenter
            .getArticleInfo()
            .subscribe(onNext: { article in
                receivedArticle = article
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        let expectedData = HelpArticle(id: 0, title: "Test title", body: "Test Body")
        XCTAssertNotNil(receivedArticle)
        XCTAssertEqual(receivedArticle?.body, expectedData.body)
    }

    func test_presenter_handleSubmitButton_enabled() {
        let sut = makeSUT()
        let submitButtonObservable = scheduler.createObserver(Bool.self)
        let mockInput = PublishSubject<String>()
        
        sut.presenter.canSubmitMessage(with: mockInput.asObservable())
            .bind(to: submitButtonObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertRecordedElements(submitButtonObservable.events, [])
        
        mockInput.onNext("")
        
        mockInput.onNext("Test")
        
        mockInput.onNext("No me entregaron mi pedido")
        
        XCTAssertRecordedElements(submitButtonObservable.events, [false, true])
    }
    
    func test_presenter_generateTicket() {
        let sut = makeSUT()
        let clientMessage = "No me entregaron mi pedido"
        sut.presenter.submitSupportTicket(clientMessage: clientMessage)
        XCTAssertEqual(sut.router.didShowSuccessMessage, true)
    }
    
    private func makeSUT(shouldFail: Bool = false) -> SUT {
        let router = RouterSpy()
        let interactor = MockInteractor(shouldFail: shouldFail)
        let presenter = HelpArticlePresenter(articleId: 0, router: router, interactor: interactor)
        return (presenter, router)
    }
}

class RouterSpy: ArticleRouter {
    
    private(set) var didShowView = false
    private(set) var didShowSuccessMessage = false
    private(set) var didShowErrorMessage = false
    
    func showArticle(with presenter: ArticlePresenter) {
        didShowView = true
    }
    
    func showError(with error: Error) {
        didShowErrorMessage = true
    }
    
    func showSuccessView() {
        didShowSuccessMessage = true
    }
}


class MockInteractor: ArticleInteractor {
    
    let shouldFail: Bool
    
    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    
    func getArticleInfo(articleId: Int) -> Single<HelpArticle> {
        return Single.create { single in
            let mockData = HelpArticle(id: articleId, title: "Test title", body: "Test Body")
            single(.success(mockData))
            return Disposables.create()
        }
    }
    
    func generateTicket(articleId: Int, clientMessage: String) -> Single<SupportTicket> {
        return Single.create { [weak self] single in
            
            guard let self = self, !self.shouldFail else {
                single(.error(RxError.unknown))
                return Disposables.create()
            }
            
            let mockData = SupportTicket(id: 0, date: Date() , clientMessage: clientMessage)
            single(.success(mockData))
            return Disposables.create()
        }
    }
}
