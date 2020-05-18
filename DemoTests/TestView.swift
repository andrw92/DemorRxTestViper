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

    func test_VC_displayTitle() {
        
        let sut = makeSUT()
        _ = sut.vc.view
        
        let mirrorObject = ViewControllerSpy(instance: sut.vc)
        XCTAssertEqual(mirrorObject.titleLabel?.text, "Test title")
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
    
    func test_VC_shouldShowSubmit() {
        let sut = makeSUT(articleId: 0)
        _ = sut.vc.view
        XCTAssertEqual(sut.vc.submitButton.isHidden, false)
    }
    
    func test_VC_shouldHideSubmit() {
        let sut = makeSUT(articleId: 1)
        _ = sut.vc.view
        XCTAssertEqual(sut.vc.submitButton.isHidden, true)
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

    
    private func makeSUT(shouldFail: Bool = false, articleId: Int = 0) -> SUT {
        let router = RouterSpy()
        let interactor = MockInteractor(shouldFail: shouldFail)
        let presenter = HelpArticlePresenter(articleId: articleId, router: router, interactor: interactor)
        let vc = HelpArticleViewController()
        vc.presenter = presenter
        return (vc, presenter, router)
    }

}

extension Mirror {
    func getMirrorVariable<T>(name: StaticString = #function) -> T? {
        return descendant("\(name)") as? T
    }
}

class ViewControllerSpy {
    
    let mirror: Mirror
    
    init(instance: Any) {
        mirror = Mirror(reflecting: instance)
    }
    
    var titleLabel: UILabel? {
        return mirror.getMirrorVariable()
    }
    
}

