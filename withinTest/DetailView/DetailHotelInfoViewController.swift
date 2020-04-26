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
class DetailHotelInfoViewController: UIViewController, DetailHotelInfoViewDelegate, StoryboardView{ 
    // MARK: - define value
    //set reactorkit
    var disposeBag = DisposeBag()
    
    //view
    @IBOutlet weak var detailHotelInfoView: DetailHotelInfoView!
    
    //hotel model
    var currentHotelModel : HotelListModel?
    
    //MARK: - Reactor Binding
    func bind(reactor: DetailHotelInfoViewReactor) {
       
       //MARK: state
       //hotelList 값 setting, setView
       reactor.state
           .map { $0.hotelList }
           .bind{ [weak self] hotelInfo in
               guard let self = self else { return }
               self.currentHotelModel = hotelInfo
               self.detailHotelInfoView.setView(hotelInfo: hotelInfo)
       }.disposed(by: self.disposeBag)
       
       //isFavorited 값 변경 때마다 값 setting
       reactor.state
           .map { $0.isFavorited }
       .bind { [weak self] (isFavorited) in
           guard let self = self else { return }
           //UPDATE view
           self.detailHotelInfoView.switchFavorite(isOn: isFavorited)
           //UPDATE model
            if self.currentHotelModel?.favorite != isFavorited{
                self.switchFavorite(isOn : isFavorited )
            }
       }
       .disposed(by: self.disposeBag)
        //MARK: Action
       //favoriteSwitch 상태 변화 - action
        self.detailHotelInfoView.favoriteSwitch.rx.isOn.changed
          .map { isOn in
              return .switchFavoriteButton(isOn: isOn) }
          .bind(to: reactor.action)
          .disposed(by: self.disposeBag)
          
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate
        detailHotelInfoView.delegate = self
        
    }
 
    // MARK: - delegate
    
    func switchFavorite(isOn: Bool) {
        //UPDATE favorite
        //UPDATE Model
        currentHotelModel?.favorite = isOn
        currentHotelModel?.saveCurrentTime()
        
        //Save favorite data at UserDefault
        if isOn == true{
            if UserDefaults.standard.object(forKey: "favorite") != nil {
                
                let userDefaults = UserDefaults.standard
                
                //get favorite List
                let decoded  = userDefaults.data(forKey: "favorite")
                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
                //append current hotel
                decodedFavorites.append(currentHotelModel ?? HotelListModel(thumbnail: "nil", name: "nil", id: -1, rate: -1, favorite: false, descriptions: ["nil" : "nil"], favoriteAssignTime: "0"))
                
                //save
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedFavorites)
                userDefaults.set(encodedData, forKey: "favorite")
                userDefaults.synchronize()
                
            }else{
                var favoriteList = [HotelListModel]()
                favoriteList.append(currentHotelModel ?? HotelListModel(thumbnail: "nil", name: "nil", id: -1, rate: -1, favorite: false, descriptions: ["nil" : "nil"], favoriteAssignTime: "0"))
                
                //save
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteList)
                userDefaults.set(encodedData, forKey: "favorite")
                userDefaults.synchronize()
                
            }
        }else if isOn == false{//delete data
            if UserDefaults.standard.object(forKey: "favorite") != nil {
                
                let userDefaults = UserDefaults.standard
                
                //get favorite List
                let decoded  = userDefaults.data(forKey: "favorite")
                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
                
                //delete current hotel
                var index = 0
                for favorite in decodedFavorites{
                    if favorite.id == currentHotelModel?.id{
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
        //hotel model 가져와서 그 안에 있는 favorite가져와서 셋팅
        self.initialState = State(hotelList: hotelList, isFavorited: hotelList.favorite)
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
            if state.hotelList.favorite != isOn { 
                newState.isFavorited = isOn
            }
            return newState
        }
    }
}
   
