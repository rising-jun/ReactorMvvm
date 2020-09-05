//
//  ModifyReactor.swift
//  ReactorMvvm2
//
//  Created by 김동준 on 2020/09/03.
//  Copyright © 2020 김동준. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
class UpdateReactor: Reactor{
    private let realmDataModel: RealmDataModel = RealmDataModel()
    private let dataConvertModel: DataConvertModel = DataConvertModel()
    enum Action {
        case update(diaryInfo: DiaryInfo)
        case loadView
    }
    
    enum Mutation{
        case requestUpdate(diaryInfo: DiaryInfo)
        case requestLoadView
    }
    
    struct State{
        var diaryInfo: DiaryInfo = DiaryInfo()
        var disViewMode: CommonResource.DisViewMode = .updateDiaryMode
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .update(diaryInfo: diaryInfo):
            return Observable.just(Mutation.requestUpdate(diaryInfo: diaryInfo))
        case .loadView:
            return Observable.just(Mutation.requestLoadView)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .requestUpdate(diaryInfo: diaryInfo):
            realmDataModel.updateDiary(diary: diaryInfo)
            newState.disViewMode = .viewDiaryMode
            break
        case .requestLoadView:
            newState.disViewMode = .updateDiaryMode
        }
        return newState
    }
}
