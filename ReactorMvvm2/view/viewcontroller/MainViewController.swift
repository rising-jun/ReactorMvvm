//
//  MainViewController.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/25.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import RxViewController
class MainViewController: UIViewController, View{
    private var selectedList: [Bool] = []
    
    var disposeBag: DisposeBag = DisposeBag()
    private let modifyItem = UIBarButtonItem()
    private let cancelItem = UIBarButtonItem()
    private let delItem = UIBarButtonItem()
    private let addItem = UIBarButtonItem()
    private let tableView = UITableView()
    
    private let wvc: WriteViewController = WriteViewController()
    private let dvc: DiaryViewController = DiaryViewController()
    
    private var diaryList: Array<DiaryInfo> = []
    public var _diaryList: Array<DiaryInfo>{
        get{
            return self.diaryList
        }
        set(val){
            self.diaryList = val
        }
    }
    
    private var delDiarlyListL: Array<DiaryInfo> = []
    
    func bind(reactor: MainReactor) {
        setTableData()
        
        
        self.rx.viewWillAppear.asSignal().map{_ in Reactor.Action.reloadList}.emit(to: reactor.action).disposed(by: disposeBag)
        
        modifyItem.rx.tap.map{Reactor.Action.modify}.bind(to: reactor.action).disposed(by: disposeBag)
        cancelItem.rx.tap.map{Reactor.Action.cancel}.bind(to: reactor.action).disposed(by: disposeBag)
        delItem.rx.tap.map{Reactor.Action.delete}.bind(to: reactor.action).disposed(by: disposeBag)
        addItem.rx.tap.map{Reactor.Action.write}.bind(to: reactor.action).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.map{
            return Reactor.Action.touchedCell(index: $0)}.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.selectedList}.distinctUntilChanged().bind { (selectedList) in
            var cell: UITableViewCell
            if(selectedList.count == 0){
                for i in 0 ..< self.diaryList.count{
                    cell = self.tableView.cellForRow(at: [0,i])!
                    cell.textLabel?.text = ""
                }
            }else{
            
            for i in 0 ..< selectedList.count{
                let cell = self.tableView.cellForRow(at: [0,i])
                if(selectedList[i]){
                    cell?.textLabel?.text = "선택됨"
                }else{
                    cell?.textLabel?.text = ""
                }
            }
            }
        }.disposed(by: disposeBag)
        
        reactor.state.map{$0.diaryList}.distinctUntilChanged().bind { (diaryList) in
            self.diaryList = diaryList
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        reactor.state.map{$0.disViewMode}.distinctUntilChanged().bind { (disViewMode) in
            if(disViewMode == .modifyListMode){
                self.setModifyModeItem()
            }else if(disViewMode == .mainViewMode){
                self.setViewModeItem()
            }else if(disViewMode == .writeViewMode){
                self.navigationController?.pushViewController(self.wvc, animated: true)
            }else if(disViewMode == .viewDiaryMode){
                self.navigationController?.pushViewController(self.dvc, animated: true)
            }
        }.disposed(by: disposeBag)
         
        reactor.state.map{$0.diaryInfo}.bind { (diaryInfo) in
            self.dvc._diaryInfo = diaryInfo
        }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        wvc.reactor = WriteReactor()
        wvc.modalPresentationStyle = .fullScreen
        
        dvc.reactor = DiaryReactor()
        dvc.modalPresentationStyle = .fullScreen
        
        setNavigationBar()
    // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        setTableView()
        
    }

    func setNavigationBar(){
        modifyItem.title = "modify"
        cancelItem.title = "cancel"
        delItem.title = "delete"
        addItem.title = "add"
        
        self.navigationItem.setRightBarButton(self.modifyItem, animated: false)
        self.navigationItem.setLeftBarButton(self.addItem, animated: false)
    }
    
    private func setModifyModeItem(){
        self.navigationItem.setLeftBarButton(self.cancelItem, animated: false)
        self.navigationItem.setRightBarButton(self.delItem, animated: false)
        
    }
    
    private func setViewModeItem(){
        self.navigationItem.setRightBarButton(self.modifyItem, animated: false)
        self.navigationItem.setLeftBarButton(self.addItem, animated: false)
        
    }
    
    private func setTableView(){
        tableView.snp.makeConstraints { (make) in
            make.height.equalTo(self.view.frame.height - self.navigationController!.navigationBar.frame.height)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        tableView.register(DiaryTitleCell.self, forCellReuseIdentifier: "customCell")
    }
   
    private func setTableData(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell",for: indexPath) as! DiaryTitleCell
        cell.awakeFromNib()
        let diary: DiaryInfo = diaryList[indexPath.row]
        cell.setCellText(title: diary._title, date: diary._date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
