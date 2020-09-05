//
//  DiaryViewController.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/09/02.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import RxViewController
class DiaryViewController: UIViewController,View{
    var disposeBag: DisposeBag = DisposeBag()
    private let uvc: UpdateViewController = UpdateViewController()
    
    private var diaryInfo: DiaryInfo = DiaryInfo()
    public var _diaryInfo: DiaryInfo{
        get{
            return self.diaryInfo
        }
        set(val){
            self.diaryInfo = val
        }
    }
    
    private let titleLabel: UILabel = UILabel()
    private let contentLabel: UILabel = UILabel()
    private let modifyItem: UIBarButtonItem = UIBarButtonItem()
    
    
    func bind(reactor: DiaryReactor) {
        self.rx.viewDidAppear.asSignal().map{_ in Reactor.Action.setUiData}.emit(to: reactor.action).disposed(by: disposeBag)
        self.navigationItem.backBarButtonItem?.rx.tap.map{Reactor.Action.back}.bind(to: reactor.action).disposed(by: disposeBag)
        modifyItem.rx.tap.map{Reactor.Action.modify}.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.disViewMode}.bind { (disViewMode) in
            if(disViewMode == .mainViewMode){
                self.navigationController?.popViewController(animated: true)
                //init
            }else if(disViewMode == .viewDiaryMode){
                self.titleLabel.text = self.diaryInfo._title
                self.contentLabel.text = self.diaryInfo._contents
            }else if(disViewMode == .updateDiaryMode){
                
                self.navigationController?.pushViewController(self.uvc, animated: true)
                
            }
        }.disposed(by: disposeBag)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uvc.modalPresentationStyle = .fullScreen
        self.uvc._diaryInfo = self.diaryInfo
        uvc.reactor = UpdateReactor()
        setLabels()
        setItemBarButton()
        view.backgroundColor = .gray
    }
    
    private func setLabels(){
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        
        titleLabel.layer.borderWidth = 1.0
        titleLabel.layer.cornerRadius = 10
        contentLabel.layer.borderWidth = 1.0
        contentLabel.layer.cornerRadius = 10
        
        titleLabel.textAlignment = .left
        contentLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 20)
        contentLabel.font = .systemFont(ofSize: 18)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(20)
            make.width.equalTo(self.view.frame.width - 40)
            make.height.equalTo(70)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(20)
            make.width.equalTo(self.view.frame.width - 40)
            make.bottom.equalTo(self.view).offset(-40)
            make.height.equalTo(650)
        }
    }
    
    private func setItemBarButton(){
        modifyItem.title = "modify"
        self.navigationItem.setRightBarButton(self.modifyItem, animated: false)
    }
    
}
