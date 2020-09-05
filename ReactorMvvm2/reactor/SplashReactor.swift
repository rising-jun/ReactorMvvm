//
//  SplashReactor.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/08/24.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa
class SplashReactor: Reactor{
    private let realmDataModel: RealmDataModel = RealmDataModel()
    private let dataConvertModel: DataConvertModel = DataConvertModel()
    enum Action {
        case readList
    }
    
    enum Mutation{
        case requestRead
    }
    
    struct State{
        var diaryList: Array<DiaryInfo> = []
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .readList:
            return Observable.just(Mutation.requestRead)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .requestRead:
            //reading title
            let result = realmDataModel.getDairy()
                newState.diaryList = dataConvertModel.resultsToArray(results: result)
            }
        return newState
    }
    
    
}
