//
//  TestView.swift
//  DemoTestTests
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import XCTest
import RxTest
@testable import Demo

class TestView: XCTestCase {
    
    typealias SUT = (vc: HelpArticleViewController, presenter: HelpArticlePresenter)

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func test_VC_displayTitle() {
        
        let sut = makeSUT()
        _ = sut.vc.view
        XCTAssertEqual(sut.vc.titleLabel.text, "Test title")
    }
    
    private func makeSUT() -> SUT {
        let router = RouterSpy()
        let interactor = MockInteractor()
        let presenter = HelpArticlePresenter(articleId: 0, router: router, interactor: interactor)
        let vc = HelpArticleViewController()
        vc.presenter = presenter
        return (vc, presenter)
    }

}
