//
//  TabBarReactor.swift
//  Hoteltime2
//
//  Created by draak on 15/02/2019.
//  Copyright © 2019 Withinnovation. All rights reserved.
//

import RxCocoa
import RxSwift
import ReactorKit

class TabBarReactor: Reactor {
    
    typealias Action = NoAction
    
    enum Mutation {
        case setFavoriteCount(Int)
    }
    
    struct State {
        var favoriteCount: Int
    }
    
    let initialState: State
    
    init() {
        let favoriteCount = LocalDB.sharedManager.favoriteCount.value
        self.initialState = State(favoriteCount: favoriteCount)
    }
    
}

extension TabBarReactor {
    
    //action 없이 싱글톤 등의 global state로부터 mutation을 촉발시키고자 할때 transform을 사용한다
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let localDB = LocalDB.sharedManager
        return Observable.merge(mutation, localDB.favoriteCount.distinctUntilChanged().map({ favoriteCount -> Mutation in
            return .setFavoriteCount(favoriteCount)
        }))
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFavoriteCount(count):
            newState.favoriteCount = count
        }
        return newState
    }
    
}
