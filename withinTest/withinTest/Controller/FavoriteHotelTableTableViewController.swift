//
//  FavoriteHotelTableTableViewController.swift
//  withinTest
//
//  Created by 김지영 on 13/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit
import Alamofire

/**
 즐겨찾기 리스트
 리스트는 이미지, 제목, 평점, 즐겨찾기 등록시간, 즐겨찾기 토글 버튼으로 구성
 - 즐겨찾기 관련 정보는 로컬 저장
 - 즐겨찾기 최근등록순, 평점순 정렬 기능 구현 (오름차순, 내림차순)
 */

class FavoriteHotelTableTableViewController: UITableViewController, FavoriteHotelTableViewCellDelegate{
    
    
    //MARK: - Define value
    
    //MARK: Model
    var favoritList = [HotelListModel]()
    
    //MARK: 상수
    let cellHeight : CGFloat = 150
    
    //delegate
    var favoriteHotelCell = FavoriteHotelTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        //get favorite List
        if let decoded  = userDefaults.data(forKey: "favorite"){
            let decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [HotelListModel]
            self.favoritList = decodedFavorites
        }
        self.tableView.reloadData()
    }

    // MARK: - delegate
    
    //즐겨찾기 버튼 누르면
    func switchFavorite(isOn: Bool, indexPathRow: Int) {
        //UPDATE Model
        self.favoritList[indexPathRow].favorite = isOn
        
        //Save favorite data at UserDefault
         //delete data
        if UserDefaults.standard.object(forKey: "favorite") != nil {
            
            let userDefaults = UserDefaults.standard
            
            //get favorite List
            let decoded  = userDefaults.data(forKey: "favorite")
            var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
            
            //delete current hotel
            var index = 0
            for favorite in decodedFavorites{
                if favorite.id == self.favoritList[indexPathRow].id{
                    decodedFavorites.remove(at: index)
                    //print("delete")
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
        DispatchQueue.main.async {
            let userDefaults = UserDefaults.standard
            //get favorite List
            let decoded  = userDefaults.data(forKey: "favorite")
            let decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
            self.favoritList = decodedFavorites
            
            self.tableView.reloadData()
        }
    }
    
    /**
     오름, 내림차순
     */
    
    //sortTableVCByRate
    func sortRateIncrease() {
        favoritList = favoritList.sorted(by: {$0.rate < $1.rate} )
        
        self.tableView.reloadData()
    }
    
    func sortRateDecrease() {
        favoritList = favoritList.sorted(by: {$0.rate > $1.rate} )
        
        self.tableView.reloadData()
    }
    
    func sortFavoriteTimeIncrease() {
        var convertedArray: [Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        for dat in favoritList {
            let date = dateFormatter.date(from: dat.favoriteAssignTime)
            if let date = date {
                convertedArray.append(date)
            }
        }
        favoritList = favoritList.sorted(by: {$0.favoriteAssignTime.compare($1.favoriteAssignTime) == .orderedAscending} )
        

        self.tableView.reloadData()
    }
    
    func sortFavoriteTimeDecrease() {
        var convertedArray: [Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        for dat in favoritList {
            let date = dateFormatter.date(from: dat.favoriteAssignTime)
            if let date = date {
                convertedArray.append(date)
            }
        }
        favoritList = favoritList.sorted(by: {$0.favoriteAssignTime.compare($1.favoriteAssignTime) == .orderedDescending} )
        self.tableView.reloadData()
        
        self.tableView.reloadData()
        
    }
    // MARK: - Table view data source
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritList.count
    }
    
    //셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell
        let cellIdentifier = "FavoriteHotelTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteHotelTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FavoriteHotelTableViewCell.")
        }
        
        //delgate
        cell.delegate = self
        
        if self.favoritList.count > 0{
            //switch tag
            cell.favoriteSwitch.tag = indexPath.row
            print( indexPath.row)
            
            //set hotel info
            let hotel = self.favoritList[indexPath.row]
            cell.name.text = hotel.name
            let url = URL(string: hotel.thumbnail)
            let data = try? Data(contentsOf: url!)
//            cell.thumbnail.image = UIImage(data: data!)
            cell.rate.text = "평점:\(String(hotel.rate))"
            cell.favoriteSwitch.isOn = hotel.favorite
            cell.favoritedTime.text = hotel.favoriteAssignTime
//            print(hotel.favoriteAssignTime)
        }
        
        return cell
    }
    
    //셀 높이지정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    //셀 선택시 새창
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailHotelInfoViewController
        
        //send model
       detailViewController.currentHotelModel = favoritList[indexPath.row]
        //fullscreen으로 present
        detailViewController.modalPresentationStyle = .fullScreen
        self.present(detailViewController, animated: true, completion: nil)
        
        
    }
    
}
