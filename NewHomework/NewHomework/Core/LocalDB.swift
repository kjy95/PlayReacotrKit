//
//  LocalDB.swift
//  NewHomework
//
//  Created by draak on 03/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import RxCocoa
import RxSwift

struct Affiliate: Codable {
    var id: Int = -1
    var name: String = ""
    var thumbnailPath: String = ""
    var imagePath: String = ""
    var subject: String = ""
    var price: Int = -1
    var rate: Float = -0.1
    var favorite: Bool = false
    var savedDate: String = ""
}

class LocalDB {
    
    //싱글톤
    static let sharedManager = LocalDB()
    
    ///즐겨찾기 총 갯수
    let favoriteCount = BehaviorRelay(value: 0)
    
    private init() {
        self.favoriteCount.accept(self.getFavoriteCount())
    }
    
    ///즐겨찾기 갯수를 가져온다
    func getFavoriteCount() -> Int {
        if let encodedData = UserDefaults.standard.value(forKey: "FavoriteDataArray") as? Data,
            let dataArray = try? JSONDecoder().decode([Affiliate].self, from: encodedData) {
            return dataArray.count
        }
        return 0
    }
    
    ///해당 id가 즐겨찾기인지 여부를 반환한다
    func getIsFavorited(id: Int) -> Bool {
        if let encodedData = UserDefaults.standard.value(forKey: "FavoriteDataArray") as? Data,
            let dataArray = try? JSONDecoder().decode([Affiliate].self, from: encodedData) {
            return dataArray.filter { $0.id == id }.first != nil
        }
        return false
    }
    
    ///즐겨찾기된 숙소를 가져온다
    func getFavoriteAffiliates() -> [Affiliate] {
        if let encodedData = UserDefaults.standard.value(forKey: "FavoriteDataArray") as? Data,
            let dataArray = try? JSONDecoder().decode([Affiliate].self, from: encodedData) {
            return dataArray
        }
        return []
    }
    
    ///즐겨찾기를 추가 또는 삭제한다
    func toggleFavorite(affiliate: Affiliate) {
    
        if let encodedData = UserDefaults.standard.value(forKey: "FavoriteDataArray") as? Data,
            let affiliates = try? JSONDecoder().decode([Affiliate].self, from: encodedData) {
            
            if (affiliates.filter { $0.id == affiliate.id }).count == 0 {
//                print("저장된 결과중 해당 값 (id \(data.id)) 없음. 값 추가")
                var newAffiliates = affiliates
                var newAffiliate = affiliate
                newAffiliate.savedDate = Date().getToday()
                newAffiliate.favorite = true
                newAffiliates.append(newAffiliate)
                
                if let encodedData = try? JSONEncoder().encode(newAffiliates) {
                    UserDefaults.standard.set(encodedData, forKey: "FavoriteDataArray")
                }
                
            } else {
//                print("저장된 결과중 해당 값 (id \(data.id)) 존재함. 값 삭제")
                let newAffiliates = affiliates.filter { $0.id != affiliate.id }
                if let encodedData = try? JSONEncoder().encode(newAffiliates) {
                    UserDefaults.standard.set(encodedData, forKey: "FavoriteDataArray")
                }
            }
            
        } else {
//            print("DB가 없음. 새로 생성후 값 추가")
            var affiliates: [Affiliate] = []
            
            var newAffiliate = affiliate
            newAffiliate.savedDate = Date().getToday()
            newAffiliate.favorite = true
            
            affiliates.append(newAffiliate)
            
            if let encodedData = try? JSONEncoder().encode(affiliates) {
                UserDefaults.standard.set(encodedData, forKey: "FavoriteDataArray")
            }
        }
        
        if let encodedData = UserDefaults.standard.value(forKey: "FavoriteDataArray") as? Data,
            let affiliates = try? JSONDecoder().decode([Affiliate].self, from: encodedData) {
//            print("저장된 결과 ---->")
//            print(affiliates)
            self.favoriteCount.accept(affiliates.count)
        }
    }

}
