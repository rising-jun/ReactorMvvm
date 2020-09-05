//
//  DiaryReactor.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/09/03.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

class DiaryReactor: Reactor{
    
    private let realmDataModel: RealmDataModel = RealmDataModel()
    private let dataConvertModel: DataConvertModel = DataConvertModel()
    enum Action {
        case back
        case setUiData
        case modify
    }
    
    enum Mutation{
        case requestBack
        case requestSetUiData
        case requestModify
    }
    
    struct State{
        var disViewMode: CommonResource.DisViewMode = .viewDiaryMode
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .back:
            return Observable.just(Mutation.requestBack)
        case .setUiData:
            return Observable.just(Mutation.requestSetUiData)
        case .modify:
            return Observable.just(Mutation.requestModify)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .requestBack:
            newState.disViewMode = .mainViewMode
            break
        case .requestSetUiData:
            newState.disViewMode = .viewDiaryMode
            break
        case .requestModify:
            newState.disViewMode = .updateDiaryMode
            break
        }
        return newState
    }
}
