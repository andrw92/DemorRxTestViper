//
//  HelpArticleViewController.swift
//  DemoTest
//
//  Created by Andres Rivas on 16-05-20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HelpArticleViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var inputTextView: UITextView!
    
    var presenter: ArticlePresenter!
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getArticleInfo()
            .subscribe(onNext: updateInfo)
            .disposed(by: disposeBag)
        
        let text = inputTextView.rx.text.asObservable().compactMap { $0 }
        presenter
            .canSubmitMessage(with: text)
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.submitInfo(with: self.inputTextView.text)
            }).disposed(by: disposeBag)
    }
    
    private func submitInfo(with message: String) {
        presenter.submitSupportTicket(clientMessage: message)
    }
    
    private func updateInfo(with article: HelpArticle) {
        titleLabel.text = article.title
        bodyLabel.text = article.body
    }

}