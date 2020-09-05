//
//  ViewController.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/24.
//  Copyright © 2020 김동준. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa
import RxSwift

class SplashViewController: UIViewController,View {
    
    var disposeBag: DisposeBag = DisposeBag()
    var diaryList: Array<DiaryInfo> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sleep(2)
        moveToMainView(diaryList: self.diaryList)
        
        // Do any additional setup after loading the view.
            
        
    }
    
    func bind(reactor: SplashReactor) {
        Observable.just(Void()).map{Reactor.Action.readList}.bind(to: reactor.action).disposed(by: disposeBag)
        reactor.state.map{$0.diaryList}.bind { (diaryList) in
            self.diaryList = diaryList
        }.disposed(by: disposeBag)
        
    }
    
    private func moveToMainView(diaryList: Array<DiaryInfo>){
        let nav = UINavigationController()
        let mvc: MainViewController = MainViewController()
        
        mvc.reactor = MainReactor()
        nav.viewControllers = [mvc]
        nav.modalPresentationStyle = .fullScreen
        mvc._diaryList = diaryList
        mvc.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true, completion: nil)
    }
}

