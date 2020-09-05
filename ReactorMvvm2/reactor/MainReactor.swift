//
//  MainReactor.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/25.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa

class MainReactor: Reactor{
    
    private let realmDataModel: RealmDataModel = RealmDataModel()
    private let dataConvertModel: DataConvertModel = DataConvertModel()
    
    enum Action {
        case modify
        case cancel
        case delete
        case write
        case initing
        case reloadList
        case touchedCell(index: IndexPath)
        
    }
    
    enum Mutation{
        case requestModify
        case requestCancel
        case requestDelete
        case requestWrite
        case requestIniting
        case requestReloadList
        case touchEventCell(index: IndexPath)
    }
    
    struct State{
        var modifyMode: Bool = false
        var disViewMode: CommonResource.DisViewMode = .mainViewMode
        var diaryList: Array<DiaryInfo> = []
        var selectedList: Array<Bool> = []
        var selectedIndex: IndexPath = []
        var diaryInfo: DiaryInfo = DiaryInfo()
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .modify:
            return Observable.just(Mutation.requestModify)
        case .cancel:
            return Observable.just(Mutation.requestCancel)
        case .delete:
            return Observable.just(Mutation.requestDelete)
        case .write:
            return Observable.just(Mutation.requestWrite)
        case .initing:
            return Observable.just(Mutation.requestIniting)
        case .reloadList:
            return Observable.just(Mutation.requestReloadList)
        case let .touchedCell(index):
            return Observable.just(Mutation.touchEventCell(index: index))
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            case .requestModify:
                newState.disViewMode = .modifyListMode
                for _ in 0 ..< newState.diaryList.count {
                    newState.selectedList.append(false)
                }
                break
            case .requestCancel:
                newState.disViewMode = .mainViewMode
                newState.selectedList = []
                break
            case .requestDelete:
                newState.disViewMode = .mainViewMode
                //delete data
                var deleteList: Array<DiaryInfo> = []
                for i in 0 ..< newState.diaryList.count{
                    if(newState.selectedList[i]){
                        deleteList.append(newState.diaryList[i])
                    }
                }
                realmDataModel.deleteDairy(deleteDiaryList: deleteList)
                newState.diaryList = dataConvertModel.resultsToArray(results: realmDataModel.getDairy())
                newState.selectedList = []
                break
            case .requestWrite:
                //update state when add data
                newState.disViewMode = .writeViewMode
                break
            case .requestIniting:
                newState.disViewMode = .mainViewMode
                break
        case .requestReloadList:
                newState.disViewMode = .mainViewMode
                newState.diaryList = dataConvertModel.resultsToArray(results: realmDataModel.getDairy())
                break
        case let .touchEventCell(index):
            if(newState.disViewMode == .modifyListMode){
                let selected = newState.selectedList[index.row]
                newState.selectedList[index.row] = dataConvertModel.changeBoolValue(val: selected)
                newState.selectedIndex = index
            }else if(newState.disViewMode == .mainViewMode){
                newState.diaryInfo = newState.diaryList[index.row]
                newState.disViewMode = .viewDiaryMode
            }
            
            break
        }
        return newState
    }
    
}
