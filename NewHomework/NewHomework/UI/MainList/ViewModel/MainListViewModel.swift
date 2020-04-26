//
//  MainListViewModel.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import RxSwift
import RxCocoa

class MainListViewModel {
    
    let list: BehaviorRelay<[Affiliate]> = BehaviorRelay(value: [])
    private var page = 1
    private var shouldRequest: Bool = true
    private let disposeBag = DisposeBag()
    
    init() {
        self.getList()
        
        //DB싱글톤의 즐겨찾기 카운트 구독
        LocalDB.sharedManager.favoriteCount.subscribe(onNext: { [weak self] count in
            guard let self = self else { return }
            self.updateFavorite()
        }).disposed(by: disposeBag)
        
    }
    
    func touchFavorite(id: Int) {
        
        if let infoData = (self.list.value.filter{ $0.id == id }.first) {
            LocalDB.sharedManager.toggleFavoriteData(data: infoData)
            self.updateFavorite()
        }
        
    }
    
    func getList() {

        if !self.shouldRequest { return }
        
        self.shouldRequest = false
        
        let listAdapter = ListAdapter()
        
        listAdapter.getMainList(page: self.page, success: { [weak self] products in
            guard let self = self else { return }

            let infoDataArray = products.map { product -> Affiliate in
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
                                    thumbnailPath: thumbnailPath,
                                    imagePath: imagePath,
                                    subject: subject,
                                    price: price,
                                    rate: rate,
                                    favorite: LocalDB.sharedManager.getIsFavorited(id: id),
                                    savedDate: Date().getToday())
                }

                return Affiliate()
            }
            
            let result = self.list.value + infoDataArray
            
            self.list.accept(result)
            self.shouldRequest = true
            self.page += 1
            
        }, failure: { error in
            print(error.debugDescription)
        })
    }
    
}

extension MainListViewModel {
    
    ///즐겨찾기를 추가 혹은 삭제한다
    private func updateFavorite() {
        let affiliates = self.list.value.map { infoData in
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
        self.list.accept(affiliates)
    }
    
}
