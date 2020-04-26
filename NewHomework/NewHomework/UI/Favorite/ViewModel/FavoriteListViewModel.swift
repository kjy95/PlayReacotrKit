//
//  FavoriteListViewModel.swift
//  NewHomework
//
//  Created by draak on 03/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import RxSwift
import RxCocoa

class FavoriteListViewModel {
    
    enum sortRuleText: String {
        case recentAscend = "최근등록순▲"
        case recentDecend = "최근등록순▼"
        case rankingAscend = "평점순▲"
        case rankingDecend = "평점순▼"
    }
    
    let list: BehaviorRelay<[Affiliate]> = BehaviorRelay(value: [])
    let sortRuleText: BehaviorRelay<sortRuleText> = BehaviorRelay(value: .recentAscend)
    private let disposeBag = DisposeBag()
    
    init() {
        self.refreshFavorite()
        
        //DB싱글톤의 즐겨찾기 카운트 구독
        LocalDB.sharedManager.favoriteCount.subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                self.refreshFavorite()
            })
            .disposed(by: disposeBag)
    }
    
    func touchFavorite(id: Int) {
        
        if let infoData = (self.list.value.filter{ $0.id == id }.first) {
            LocalDB.sharedManager.toggleFavoriteData(data: infoData)
            self.refreshFavorite()
        }
        
    }
    
    ///정렬 기준을 다음 차례로 변경후 재정렬한다
    func updateFavorite() {
        
        switch self.sortRuleText.value {
        case .recentAscend:
            self.sortRuleText.accept(.recentDecend)
            break
        case .recentDecend:
            self.sortRuleText.accept(.rankingAscend)
            break
        case .rankingAscend:
            self.sortRuleText.accept(.rankingDecend)
            break
        case .rankingDecend:
            self.sortRuleText.accept(.recentAscend)
            break
        }
        self.refreshFavorite()
    }
    
}

extension FavoriteListViewModel {
    
    private func refreshFavorite() {
        let favoriteListData = LocalDB.sharedManager.getFavoriteListData()
        var sortedListData: [Affiliate] = []
        
        switch self.sortRuleText.value {
        case .recentAscend:
            sortedListData = favoriteListData.sorted(by: { $0.savedDate.getDateFromString() > $1.savedDate.getDateFromString() })
            break
        case .recentDecend:
            sortedListData = favoriteListData.sorted(by: { $0.savedDate.getDateFromString() < $1.savedDate.getDateFromString() })
            break
        case .rankingAscend:
            sortedListData = favoriteListData.sorted(by: { $0.rate > $1.rate })
            break
        case .rankingDecend:
            sortedListData = favoriteListData.sorted(by: { $0.rate < $1.rate })
            break
        }
        self.list.accept(sortedListData)
    }
    
}
