//
//  DetailViewReactor.swift
//  NewHomework
//
//  Created by draak on 03/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

class DetailViewReactor: Reactor {
    
    enum Action {
        case favoriteButtonTap
    }
    
    enum Mutation {
        case toggleFavorite(Bool)
    }
    
    struct State {
        var affiliate: Affiliate
    }
    
    let initialState: State
    
    init(affiliate: Affiliate) {
        self.initialState = State(affiliate: affiliate)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let localDB = LocalDB.sharedManager
        let id = self.initialState.affiliate.id
        //merge : lhs와 rhs중 들어오는 놈으로 방출한다
        return Observable.merge(mutation, localDB.favoriteCount.distinctUntilChanged().map({ _ -> Mutation in
            return Mutation.toggleFavorite(localDB.getIsFavorited(id: id))
        }))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .favoriteButtonTap:
            LocalDB.sharedManager.toggleFavorite(affiliate: self.initialState.affiliate)
            let isFavorited = LocalDB.sharedManager.getIsFavorited(id: self.initialState.affiliate.id)
            return Observable.just(.toggleFavorite(isFavorited))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .toggleFavorite(isFavorite):
            newState.affiliate.favorite = isFavorite
        }
        return newState
    }
    
}
