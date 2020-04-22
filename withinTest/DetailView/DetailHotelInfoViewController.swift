//
//  DetailHotelInfoViewController.swift
//  withinTest
//
//  Created by 김지영 on 13/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

/**
 상세 뷰 컨트롤러
 */
class DetailHotelInfoViewController: UIViewController, DetailHotelInfoViewDelegate{
    // MARK: - define value
    
    //view
    @IBOutlet weak var detailHotelInfoView: DetailHotelInfoView!
    
    //hotel model
    var currentHotelModel : HotelListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        detailHotelInfoView.delegate = self
        
        //set view
        detailHotelInfoView.setView(hotelInfo: currentHotelModel ?? HotelListModel(thumbnail: "nil", name: "nil", id: -1, rate: -1, favorite: false, descriptions: ["nil" : "nil"], favoriteAssignTime: "0"))
    }
    
 
    // MARK: - delegate
    
    func switchFavorite(isOn: Bool) {
        //UPDATE favorite
        //UPDATE Model
        self.currentHotelModel?.favorite = isOn
        self.currentHotelModel?.saveCurrentTime()
        //UPDATE View
        self.detailHotelInfoView.switchFavorite(isOn: isOn)
        
        
        //Save favorite data at UserDefault
        if isOn{
            if UserDefaults.standard.object(forKey: "favorite") != nil {
                
                let userDefaults = UserDefaults.standard
                
                //get favorite List
                let decoded  = userDefaults.data(forKey: "favorite")
                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
                //append current hotel
                decodedFavorites.append(self.currentHotelModel ?? HotelListModel(thumbnail: "nil", name: "nil", id: -1, rate: -1, favorite: false, descriptions: ["nil" : "nil"], favoriteAssignTime: "0"))
                
                //save
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedFavorites)
                userDefaults.set(encodedData, forKey: "favorite")
                userDefaults.synchronize()
                
            }else{
                var favoriteList = [HotelListModel]()
                favoriteList.append(self.currentHotelModel ?? HotelListModel(thumbnail: "nil", name: "nil", id: -1, rate: -1, favorite: false, descriptions: ["nil" : "nil"], favoriteAssignTime: "0"))
                
                //save
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteList)
                userDefaults.set(encodedData, forKey: "favorite")
                userDefaults.synchronize()
                
            }
        }else if !isOn{//delete data
            if UserDefaults.standard.object(forKey: "favorite") != nil {
                
                let userDefaults = UserDefaults.standard
                
                //get favorite List
                let decoded  = userDefaults.data(forKey: "favorite")
                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
                
                //delete current hotel
                var index = 0
                for favorite in decodedFavorites{
                    if favorite.id == self.currentHotelModel?.id{
                        decodedFavorites.remove(at: index) 
                        break
                    }
                    index += 1
                }
                
                //save
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedFavorites)
                userDefaults.set(encodedData, forKey: "favorite")
                userDefaults.synchronize()
                
            }else{
                print("error")
            }
        }
    }
    
    func exitButton() {
        self.dismiss(animated: true)
    }
     
}

class DetailHotelInfoViewReactor: Reactor {
    
    enum Action {
        case switchFavoriteButton(isOn: Bool)
    }
    
    enum Mutation {
        case switchFavorite(Bool)
    }
    
    struct State {
        var hotelList: HotelListModel
        var isFavorited: Bool
    }
 
    let initialState: State
    
    init(hotelList: HotelListModel) {
        self.initialState = State(hotelList: hotelList, isFavorited: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .switchFavoriteButton(isOn):
            let isFavorited = isOn
            return Observable.just(Mutation.switchFavorite(isFavorited))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .switchFavorite(isOn):
            newState.hotelList.favorite = isOn
            return newState
        }
    }
}
