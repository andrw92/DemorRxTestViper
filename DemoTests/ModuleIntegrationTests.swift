//
//  ModuleIntegrationTests.swift
//  DemoTests
//
//  Created by Aldo Martinez on 5/17/20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import XCTest
import OHHTTPStubs
import RxSwift
import RxBlocking
@testable import Demo

class ModuleIntegrationTests: XCTestCase {
    
    typealias Module = (presenter: ArticlePresenter, interactor: ArticleInteractorProtocol, router: HelpArticleRouterProtocol)
    
    private let articleId: Int = 1
    private var navigation: MockNavigation!
    
    override func setUp() {
        super.setUp()
        navigation = MockNavigation()
    }
    
    override func tearDown() {
        super.tearDown()
        navigation = nil
        HTTPStubs.removeAllStubs()
    }
    
    func testShowsModule() {
        let module = makeModule()
        module.router.showArticle(with: module.presenter)
        
        guard let _ = navigation.presentedView as? HelpArticleViewController else {
            XCTAssert(false)
            return
        }
        XCTAssert(true)
    }
    
    // Test 2 components
    func testPresenterGetsArticle() {
        defaultStub(urlEndsWith: "/article/\(articleId)", jsonMock: TestMocks.article.rawValue)
        
        let module = makeModule()
        module.router.showArticle(with: module.presenter)
        
        guard let article = try? module.presenter.getArticleInfo().toBlocking().first() else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(article.id == 1)
        XCTAssert(article.title == "Title")
        XCTAssert(article.body == "Lorem Ipsum")
    }
    
    // Test 4 components
    func testViewGetsArticle() {
        defaultStub(urlEndsWith: "/ticket/create", jsonMock: TestMocks.ticket.rawValue)
        
        let module = makeModule()
        module.router.showArticle(with: module.presenter)
        let view = navigation.presentedView as? HelpArticleViewController
        view?.loadView()
        let testExpectation = expectation(description: "MIExpectation")
        
        let observation = view?.titleLabel.observe(\UILabel.text, options: [.new, .old]) { label, change in
            testExpectation.fulfill()
        }
        module.presenter.submitSupportTicket(clientMessage: "Hello World")
        
        waitForExpectations(timeout: 3.0, handler: nil)
        XCTAssert(view?.titleLabel.text == "Success")
        XCTAssert(view?.bodyLabel.text == "Lorem ipsum")
        observation?.invalidate()
    }
    
    private func makeModule() -> Module {
        let interactor = ArticleInteractor()
        let router = HelpArticleRouter(navigation: navigation)
        let presenter = HelpArticlePresenter(articleId: articleId, router: router, interactor: interactor)
        
        return (presenter: presenter, interactor: interactor, router: router)
    }
    
}
