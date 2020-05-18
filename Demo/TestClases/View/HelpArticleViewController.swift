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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    
    var presenter: ArticlePresenter!
    private let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: String(describing: HelpArticleViewController.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getArticleInfo()
            .subscribe(onNext: updateInfo)
            .disposed(by: disposeBag)
        
        let initialText = inputTextView.text ?? ""
        
        let text = inputTextView.rx.didChange.compactMap { self.inputTextView.text }.asObservable().startWith(initialText)
        
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
    
    func showError() {
        titleLabel.text = "Error"
        bodyLabel.text = "Ocurrió un error, inténtelo de nuevo"
    }
    
    func showSuccessView() {
        titleLabel.text = "Success"
        bodyLabel.text = "Lorem ipsum"
    }

}
