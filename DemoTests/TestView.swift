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
    
    typealias SUT = (vc: HelpArticleViewController, presenter: HelpArticlePresenter, router: RouterSpy)

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func test_VC_displayTitle() {
        
        let sut = makeSUT()
        _ = sut.vc.view
        XCTAssertEqual(sut.vc.titleLabel.text, "Test title")
    }
    
    func test_VC_submitButton_EnabledState() {
        let sut = makeSUT()
        _ = sut.vc.view
        
        XCTAssertEqual(sut.vc.submitButton.isEnabled, false)
        sut.vc.inputTextView.insertText("Necesito ayuda con mi pedido")
        XCTAssertEqual(sut.vc.submitButton.isEnabled, true)
        
        sut.vc.submitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(sut.router.didShowSuccessMessage, true)
    }
    
    func test_VC_submitButton_ShouldFail() {
        let sut = makeSUT(shouldFail: true)
        _ = sut.vc.view
        
        XCTAssertEqual(sut.vc.submitButton.isEnabled, false)
        sut.vc.inputTextView.insertText("Necesito ayuda con mi pedido")
        XCTAssertEqual(sut.vc.submitButton.isEnabled, true)
        
        sut.vc.submitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(sut.router.didShowSuccessMessage, false)
        XCTAssertEqual(sut.router.didShowErrorMessage, true)
    }

    
    private func makeSUT(shouldFail: Bool = false) -> SUT {
        let router = RouterSpy()
        let interactor = MockInteractor(shouldFail: shouldFail)
        let presenter = HelpArticlePresenter(articleId: 0, router: router, interactor: interactor)
        let vc = HelpArticleViewController()
        vc.presenter = presenter
        return (vc, presenter, router)
    }

}
