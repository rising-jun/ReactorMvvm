//
//  WriteReactor.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/28.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa
class WriteReactor: Reactor{
    
    private let realmDataModel: RealmDataModel = RealmDataModel()
    private let dataConvertModel: DataConvertModel = DataConvertModel()
    
    enum Action {
        case cancel
        case write(title: String,contents: String)
    }
    
    enum Mutation{
        case requestCancel
        case requestWrite(title:String,contents:String)
    }
    
    struct State{
        var disViewMode: CommonResource.DisViewMode = .writeViewMode
        var diary: DiaryInfo = DiaryInfo()
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancel:
            return Observable.just(Mutation.requestCancel)
        case let .write(title,contents):
            return Observable.just(Mutation.requestWrite(title: title, contents: contents))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .requestCancel:
            newState.disViewMode = .mainViewMode
            break
            
        case let .requestWrite(title,contents):
            newState.disViewMode = .mainViewMode
            let diaryInfo:DiaryInfo = DiaryInfo()
            diaryInfo._title = title
            diaryInfo._contents = contents
            diaryInfo._date = dataConvertModel.getDate()
            diaryInfo._uid = NSUUID().uuidString
            realmDataModel.wrtieDairy(diary: diaryInfo)
            
            break
        }
        return newState
    }
    
    
}
