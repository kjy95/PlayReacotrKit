//
//  MainListViewCellReactor.swift
//  NewHomework
//
//  Created by draak on 02/04/2020.
//  Copyright © 2020 Draak. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class MainListViewCellReactor: Reactor {
    
    enum Action {
        case favoriteButtonTap
    }
    
    enum Mutation {
        case toggleIsFavorite(Bool)
    }
    
    struct State {
        var affiliate: Affiliate
    }
    
    let initialState: State
    
    init(affiliate: Affiliate) {
        self.initialState = State(affiliate: affiliate)
        _ = self.state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .favoriteButtonTap:
            LocalDB.sharedManager.toggleFavorite(affiliate: self.initialState.affiliate)
            let isFavorited = LocalDB.sharedManager.getIsFavorited(id: self.initialState.affiliate.id)
            return Observable.just(.toggleIsFavorite(isFavorited))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .toggleIsFavorite(isFavorite):
            newState.affiliate.favorite = isFavorite
        }
        return newState
    }
    
    //    func transform(mutation: Observable<MainListViewCellReactor.Mutation>) -> Observable<MainListViewCellReactor.Mutation> {
    //          let localDB = LocalDB.sharedManager
    //          return Observable.merge(mutation, localDB.favoriteCount.distinctUntilChanged().map({ _ -> Mutation in
    //            return Mutation.updateIsFavorite(self.updateIsFavorite(affiliate: self.currentState.affiliate))
    //          }))
    //      }
}
