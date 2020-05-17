//
//  HelpArticleRouter.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleRouter {
    func showArticle(with presenter: ArticlePresenter)
    func showError(with error: Error)
    func showSuccessView()
}
