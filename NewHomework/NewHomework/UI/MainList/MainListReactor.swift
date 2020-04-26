//
//  MainListReactor.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import RxSwift
import RxCocoa
import ReactorKit

class MainListReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case initialize
        case loadMore
    }
    
    enum Mutation {
        case loadData([Affiliate], nextPage: Int?)
        case appendData([Affiliate], nextPage: Int?)
        case updateFavorite([Affiliate])
    }
    
    struct State {
        var affiliates: [Affiliate]
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.initialState = State(affiliates: [])
    }
}

extension MainListReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .initialize:
            return self.getList(page: 1).map { Mutation.loadData($0, nextPage: $1) }
        case .loadMore:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return self.getList(page: page).map { Mutation.appendData($0, nextPage: $1) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .loadData(infoDatas, nextPage):
            newState.affiliates = infoDatas
            newState.nextPage = nextPage
        case let .appendData(infoDatas, nextPage):
            newState.affiliates.append(contentsOf: infoDatas)
            newState.nextPage = nextPage
        case let .updateFavorite(infoDatas):
            newState.affiliates = infoDatas
        }
        return newState
    }
    
    //각각의 즐겨찾기가 변할때마다 메인 리스트 리액터에서 각 셀에 들어갈 데이터를 갱신하는데 이거를 각 셀쪽으로 옮길수 있을지 체크 해보자.
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let localDB = LocalDB.sharedManager
        //merge : lhs와 rhs중 들어오는 놈으로 방출한다
        return Observable.merge(mutation, localDB.favoriteCount.distinctUntilChanged().map({ _ -> Mutation in
            return Mutation.updateFavorite(self.updateFavorite(infoDatas: self.currentState.affiliates))
        }))
    }
}

extension MainListReactor {
    
    private func convertDomain(path: String) -> String {
        return path.replacingOccurrences(of: "withinnovation", with: "gccompany")
    }
    
    private func getList(page: Int) -> Observable<(affiliates: [Affiliate], nextPage: Int?)> {
        return Observable<(affiliates: [Affiliate], nextPage: Int?)>.create({ (observer) -> Disposable in
            ListAdapter().getMainList(page: page, success: { (products) in
                let affiliates = products.map { product -> Affiliate in
                    if let product = product,
                        let id = product.id,
                        let name = product.name,
                        let imagePath = product.description?.imagePath,
                        let subject = product.description?.subject,
                        let price = product.description?.price,
                        let thumbnailPath = product.thumbnail,
                        let rate = product.rate
                    {
                        return Affiliate(id: id,
                                         name: name,
                                         thumbnailPath: self.convertDomain(path: thumbnailPath),
                                         imagePath: self.convertDomain(path: imagePath),
                                         subject: subject,
                                         price: price,
                                         rate: rate,
                                         favorite: LocalDB.sharedManager.getIsFavorited(id: id),
                                         savedDate: Date().getToday())
                    }
                    
                    return Affiliate()
                }
                let nextPage = page + 1
                //                print("api call - page: \(nextPage)")
                observer.onNext((affiliates: affiliates, nextPage: nextPage))
                observer.onCompleted()
            }) { (error) in
                let errorCode = error?.errorCode ?? "-999"
                let code = Int(errorCode) ?? -999
                observer.onError(NSError(domain: error.debugDescription, code: code, userInfo: nil))
            }
            return Disposables.create()
        })
    }
    
    private func updateFavorite(infoDatas: [Affiliate]) -> [Affiliate] {
        let infoDataArray = infoDatas.map { infoData in
            return Affiliate(id: infoData.id,
                             name: infoData.name,
                             thumbnailPath: infoData.thumbnailPath,
                             imagePath: infoData.imagePath,
                             subject: infoData.subject,
                             price: infoData.price,
                             rate: infoData.rate,
                             favorite: LocalDB.sharedManager.getIsFavorited(id: infoData.id),
                             savedDate: Date().getToday())
        }
        return infoDataArray
    }
    
}
