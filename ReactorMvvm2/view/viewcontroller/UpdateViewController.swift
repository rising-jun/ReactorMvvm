//
//  ModifyViewController.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/09/03.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import ReactorKit
import RxViewController

class UpdateViewController: UIViewController, View{
    var disposeBag: DisposeBag = DisposeBag()
    private var diaryInfo: DiaryInfo = DiaryInfo()
    public var _diaryInfo: DiaryInfo{
        get{
            return self.diaryInfo
        }set(val){
            self.diaryInfo = val
        }
    }
    private var titleString: String = ""
    private var contentString: String = ""
    
    
    private let updateItem: UIBarButtonItem = UIBarButtonItem()
    private let titleField = UITextField()
    private let contentField = UITextView()
    
    func bind(reactor: UpdateReactor) {
        
        self.rx.viewWillAppear.asSignal().map{_ in Reactor.Action.loadView}.emit(to: reactor.action).disposed(by: disposeBag)
        
        titleField.rx.text.orEmpty.distinctUntilChanged().bind { (title) in
            self.titleString = title
        }.disposed(by: disposeBag)
        
        contentField.rx.text.orEmpty.distinctUntilChanged().bind { (contents) in
            self.contentString = contents
        }.disposed(by: disposeBag)
        
        updateItem.rx.tap.map{Reactor.Action.update(diaryInfo: self.setUpdateDiaryInfo())}.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.disViewMode}.distinctUntilChanged().bind { (disViewMode) in
            if(disViewMode == .viewDiaryMode){
                self.navigationController?.popViewController(animated: true)
            }else if(disViewMode == .updateDiaryMode){
                self.titleField.text = self.diaryInfo._title
                self.contentField.text = self.diaryInfo._contents
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setBarItem()
        setTextField()
    }
    
    private func setBarItem(){
        updateItem.title = "update"
        self.navigationItem.setRightBarButton(self.updateItem, animated: false)
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
        
        //titleField.placeholder = "  제목을 입력해주세요"
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
    func setUpdateDiaryInfo() -> DiaryInfo{
        let updateDiaryInfo: DiaryInfo = DiaryInfo()
        updateDiaryInfo._title = self.titleString
        updateDiaryInfo._contents = self.contentString
        updateDiaryInfo._date = self.diaryInfo._date
        updateDiaryInfo._uid = self.diaryInfo._uid
        return updateDiaryInfo
    }
    
}
