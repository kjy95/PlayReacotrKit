//
//  TabBarViewModel.swift
//  PlayReactorKit
//
//  Created by tori on 17/04/2020.
//  Copyright © 2020 tori. All rights reserved.
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
        let favoriteCount = 0
        self.initialState = State(favoriteCount: favoriteCount)
    }
}

extension TabBarReactor {
    
}
