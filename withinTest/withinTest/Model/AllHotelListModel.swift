//
//  AllListModel.swift
//  withinTest
//
//  Created by 김지영 on 12/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit

/**
 호텔 정보 API
 */
class HotelListModel : NSObject, NSCoding{
    
    var descriptions = [String : Any]()
    var thumbnail : String
    var name : String
    var id : Int
    var rate : Double
    var favorite : Bool
    //when favorite true, date assign
    var favoriteAssignTime = String()
    
    init(thumbnail: String, name: String, id: Int, rate: Double, favorite: Bool, descriptions: [String : Any], favoriteAssignTime: String){
        self.thumbnail = thumbnail
        self.name = name
        self.id = id
        self.rate = rate
        self.favorite = favorite
        self.favoriteAssignTime = favoriteAssignTime
        self.descriptions = descriptions
    }
    
    /**
     userdefault에 저장시 인코딩. 디코딩
     */
    //디코딩
    required convenience init?(coder aDecoder: NSCoder) {
        let thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let id = aDecoder.decodeInteger(forKey: "id")
        let rate = aDecoder.decodeDouble(forKey: "rate")
        let favorite = aDecoder.decodeBool(forKey: "favorite")
        let descriptions = aDecoder.decodeObject(forKey: "descriptions") as! [String : Any]
        let favoriteAssignTime = aDecoder.decodeObject(forKey: "favoriteAssignTime") as! String
        
        self.init(thumbnail: thumbnail, name: name, id: id, rate: rate, favorite: favorite, descriptions: descriptions, favoriteAssignTime: favoriteAssignTime)
    }
    
    //인코딩
    func encode(with aCoder: NSCoder) {
        //print("\(thumbnail)\n\(name)\n\(id)\n\(rate)\n\(favorite)\n\(descriptions)")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(rate, forKey: "rate")
        aCoder.encode(favorite, forKey: "favorite")
        aCoder.encode(descriptions, forKey: "descriptions")
        aCoder.encode(favoriteAssignTime, forKey: "favoriteAssignTime")
    }
    
    func saveCurrentTime(){
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        favoriteAssignTime = formatter.string(from: now)
    }
}
