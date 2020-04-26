//
//  FavoriteListReactor.swift
//  NewHomework
//
//  Created by draak on 03/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import RxSwift
import RxCocoa
import ReactorKit

class FavoriteListReactor: Reactor {
    
    enum SortRule: String {
        case recentAscend = "최근부터"
        case recentDecend = "과거부터"
        case rankingAscend = "높은평점"
        case rankingDecend = "낮은평점"
    }
    
    var initialState: State
    
    enum Action {
        case initialize
        case sortRuleChange
    }
    
    enum Mutation {
        case setFavoritedAffiliates(affiliates: [Affiliate], sortRule: SortRule)
    }
    
    struct State {
        var affiliates: [Affiliate]
        var sortRule: SortRule
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.initialState = State(affiliates: [], sortRule: .recentAscend)
    }
    
}

extension FavoriteListReactor {
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let localDB = LocalDB.sharedManager
        //merge : lhs와 rhs중 들어오는 놈으로 방출한다
        return Observable.merge(mutation,
                                localDB.favoriteCount.distinctUntilChanged()
                                    .map { _ in
                                        let sortRule = self.currentState.sortRule
                                        let favoriteAffiliates = self.getFavoriteAffiliates(sortRule: sortRule)
                                        return Mutation.setFavoritedAffiliates(affiliates: favoriteAffiliates, sortRule: sortRule) })
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .initialize:
            let sortRule = self.currentState.sortRule
            return Observable.just(Mutation.setFavoritedAffiliates(affiliates: self.getFavoriteAffiliates(sortRule: sortRule), sortRule: sortRule))
        case .sortRuleChange:
            let changedSortRule = self.changeToNextSortRule(currentSortRule: self.currentState.sortRule)
            return Observable.just(Mutation.setFavoritedAffiliates(affiliates: self.getFavoriteAffiliates(sortRule: changedSortRule), sortRule: changedSortRule))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        switch mutation {
        case let .setFavoritedAffiliates(affiliates, sortRule):
            newState.affiliates = affiliates
            newState.sortRule = sortRule
        }
        return newState
        
    }
    
}

extension FavoriteListReactor {
    
    //즐겨찾기 데이터를 가져와서 정렬 기준에 맞춰 정렬한 뒤 뿌린다
    private func getFavoriteAffiliates(sortRule: SortRule) -> [Affiliate] {
        
        let favoriteAffiliates = LocalDB.sharedManager.getFavoriteAffiliates()
        switch sortRule {
        case .recentAscend:
            return favoriteAffiliates.sorted(by: { $0.savedDate.getDateFromString() > $1.savedDate.getDateFromString() })
        case .recentDecend:
            return favoriteAffiliates.sorted(by: { $0.savedDate.getDateFromString() < $1.savedDate.getDateFromString() })
        case .rankingAscend:
            return favoriteAffiliates.sorted(by: { $0.rate > $1.rate })
        case .rankingDecend:
            return favoriteAffiliates.sorted(by: { $0.rate < $1.rate })
        }
        
    }
    
    ///정렬 기준을 다음 차례로 변경한다
    private func changeToNextSortRule(currentSortRule: SortRule) -> SortRule {
        
        switch currentSortRule {
        case .recentAscend:
            return .recentDecend
        case .recentDecend:
            return .rankingAscend
        case .rankingAscend:
            return .rankingDecend
        case .rankingDecend:
            return .recentAscend
        }
        
    }
}
