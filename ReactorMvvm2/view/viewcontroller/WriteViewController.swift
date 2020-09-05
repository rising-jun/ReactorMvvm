//
//  WriteViewController.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/28.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

class WriteViewController: UIViewController, View{
    var disposeBag: DisposeBag = DisposeBag()
    private let cancelItem = UIBarButtonItem()
    private let addItem = UIBarButtonItem()
    private let titleField = UITextField()
    private let contentField = UITextView()
    private var titleVal: String = ""
    private var contentVal: String = ""
    
    func bind(reactor: WriteReactor) {
        cancelItem.rx.tap.map{Reactor.Action.cancel}.bind(to: reactor.action).disposed(by: disposeBag)
        addItem.rx.tap.map{Reactor.Action.write(
            title: self.titleVal,
            contents: self.contentVal
            )}
            .bind(to: reactor.action).disposed(by: disposeBag)
        
        titleField.rx.text.orEmpty.distinctUntilChanged().bind { (title) in
            self.titleVal = title
        }.disposed(by: disposeBag)
        
        contentField.rx.text.orEmpty.distinctUntilChanged().bind { (contents) in
            self.contentVal = contents
        }.disposed(by: disposeBag)
        
        reactor.state.map{$0.disViewMode}.bind { (disViewMode) in
            if(disViewMode == .mainViewMode){
                self.navigationController?.popViewController(animated: true)
                self.titleField.text = ""
                self.contentField.text = ""
                self.titleVal = ""
                self.contentVal = ""
            }
        }.disposed(by: disposeBag)
    
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        setNavigationItem()
        setTextField()
        
    }
    
    private func setNavigationItem(){
        cancelItem.title = "cancle"
        addItem.title = "write"
        self.navigationItem.setRightBarButton(self.cancelItem, animated: false)
        self.navigationItem.setLeftBarButton(self.addItem, animated: false)
    }
    
    private func setTextField(){
        self.view.addSubview(titleField)
        self.view.addSubview(contentField)
        
        titleField.layer.borderWidth = 1.0
        titleField.layer.cornerRadius = 10
        contentField.layer.borderWidth = 1.0
        contentField.layer.cornerRadius = 15
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        titleField.leftView = leftView
        titleField.leftViewMode = .always
        
        titleField.placeholder = "  제목을 입력해주세요"
        //contentField.placeholder = "  오늘의 일을 기록해주세요"
        
        titleField.textAlignment = .left
        contentField.textAlignment = .left
        contentField.font = .systemFont(ofSize: 18)
        
        //contentField.font = contentField.font?.withSize(100)
        
        titleField.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(20)
            make.width.equalTo(self.view.frame.width - 40)
            make.height.equalTo(70)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        contentField.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(20)
            make.width.equalTo(self.view.frame.width - 40)
            make.bottom.equalTo(self.view).offset(-40)
            make.height.equalTo(650)
            
        }
        
    }
}
