//
//  HelpArticleRouter.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation
import UIKit

protocol HelpArticleRouterProtocol: class {    
    func showArticle(with presenter: ArticlePresenter)
    func showError(with error: Error)
    func showSuccessView()
}

class HelpArticleRouter: HelpArticleRouterProtocol {
    
    weak var navigation: UINavigationController?
    weak var baseController: HelpArticleViewController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func showArticle(with presenter: ArticlePresenter) {
        let vc = HelpArticleViewController()
        vc.presenter = presenter
        baseController = vc
        navigation?.present(vc, animated: true, completion: nil)
    }
    
    func showError(with error: Error) {
        baseController?.showError()
    }
    
    func showSuccessView() {
        baseController?.showSuccessView()
    }
    
}
