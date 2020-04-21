//
//  AllHotelTableViewController.swift
//  withinTest
//
//  Created by 김지영 on 13/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit
import Alamofire

/**
 모든 호텔리스트
 */

class AllHotelTableViewController: UITableViewController, AllHotelTableViewCellDelegate {
    
    //MARK: - Define value
    
    //MARK: Model
    var allList = [HotelListModel]()
    
    //delegate
    var allHotelCell = AllHotelTableViewCell()
    
    //MARK: 상수
    //url
    let url1 = "https://gccompany.co.kr/App/json/1.json"
    let url2 = "https://gccompany.co.kr/App/json/2.json"
    let url3 = "https://gccompany.co.kr/App/json/3.json"
    
    //page
    
    // 테이블 뷰 바닥까지 왔는지 처음 한번만 확인 flag
    var isLoadTableView = false
    
    //MARK: - VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate
        allHotelCell.delegate = self
        
        //remove
        //UserDefaults.standard.removeObject(forKey: "favorite")
        
        getHotelInfo(url: url1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //즐겨찾기 탭에서 즐겨찾기가 변할 경우가 있으므로 다시 테이블 뷰 로드
        //get API
        //getHotelInfo(url: url1)
        //디테일 뷰에서 exit했을 때, 즐겨찾기가 변할 경우가 있으므로 다시 테이블 뷰 로드
        self.tableView.reloadData()
    }
    
    // MARK: - 계산 함수
     
    private func getHotelInfo(url: String){
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                //to get JSON return value
                switch response.result {
                case let .success(value):
                    //필요 딕셔너리 파싱
                    if let jsonDict = value as? [String : Any], let dataArray = jsonDict["data"] as? [String : Any], let productArray = dataArray["product"] as? [[String:Any]]{
                        //save model
                        for product in productArray{
                            //get info from api
                            let descriptions = product["description"] as! [String : Any]
                            let thumbnail =  product["thumbnail"] as! String
                            let name =  product["name"] as! String
                            let id = product["id"] as! Int
                            let rate =  product["rate"] as! NSNumber.FloatLiteralType
                            
                            //get info from local
                            //get favorite List
                            var favorite = false
                            var favoriteAssignTime = "0"
                            let userDefaults = UserDefaults.standard
                            if let decoded  = userDefaults.data(forKey: "favorite"){
                                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [HotelListModel]
                                for favoriteHotel in decodedFavorites{
                                    if favoriteHotel.id == id{
                                        favorite = true
                                        favoriteAssignTime = favoriteHotel.favoriteAssignTime
                                        print("tu")
                                        break
                                    }
                                }
                            }
                            
                            let tempAllList = HotelListModel(thumbnail: thumbnail, name: name, id: id, rate: rate, favorite: favorite, descriptions: descriptions, favoriteAssignTime: favoriteAssignTime)
                            
                            self.allList.append(tempAllList)
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                }
                
                self.tableView.reloadData()
        }
    }
    
    // MARK: - delegate
    
    //즐겨찾기 버튼 누르면
    func switchFavorite(isOn: Bool, indexPathRow: Int) {
        //UPDATE Model
        self.allList[indexPathRow].favorite = isOn
        self.allList[indexPathRow].saveCurrentTime()
        
        //Save favorite data at UserDefault
        if isOn{
            if UserDefaults.standard.object(forKey: "favorite") != nil {
                
                let userDefaults = UserDefaults.standard
                
                //get favorite List
                let decoded  = userDefaults.data(forKey: "favorite")
                
                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [HotelListModel]
               
                //append current hotel
                decodedFavorites.append(self.allList[indexPathRow])
                
                //save
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedFavorites)
                userDefaults.set(encodedData, forKey: "favorite")
                userDefaults.synchronize()
                
            }else{
                var favoriteList = [HotelListModel]()
                favoriteList.append(self.allList[indexPathRow])
                
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
                    if favorite.id == self.allList[indexPathRow].id{
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
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allList.count
    }

    //셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell
        let cellIdentifier = "AllHotelCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllHotelTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AllHotelTableViewCell.")
        }
        //delgate
        cell.delegate = self
        
        if self.allList.count > 0{
            //switch tag
            cell.favoriteSwitch.tag = indexPath.row
            
            
            //set hotel info
            let hotel = self.allList[indexPath.row]
            cell.name.text = hotel.name
            let url = URL(string: hotel.thumbnail)
            let data = try? Data(contentsOf: url!)
            cell.thumbnail.image = UIImage(data: data!)
            cell.rate.text = "평점:\(String(hotel.rate))"
            cell.favoriteSwitch.isOn = hotel.favorite
            
            //get info from local
            //get favorite List
            var favorite = false
            let userDefaults = UserDefaults.standard
            if let decoded  = userDefaults.data(forKey: "favorite"){
                var decodedFavorites = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [HotelListModel]
                for favoriteHotel in decodedFavorites{
                    if favoriteHotel.id == hotel.id{
                        favorite = true
                        print("tu")
                        break
                    }
                }
            }
            self.allList[indexPath.row].favorite = favorite
            
            cell.favoriteSwitch.isOn = hotel.favorite
        }

        return cell
    }
    
    //셀 높이지정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK: paging
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /**
         테이블 뷰의 마지막 리스트를 봤을 때 새로운 데이터를 가져옴.
         테이블 뷰 리스트가 allList 갯수와 같은지 확인. 같으면 새 데이터 가져옴.
         (처음 테이블 뷰 로드할 땐, 모든 row를 가져오므로 처음 부를 때는 새 데이터를 안가져오게함)
         */
        if indexPath.row == allList.count - 1{
            if  allList.count == 20{
                getHotelInfo(url: url2)
                print("url2:")
            }else if allList.count == 40{
                getHotelInfo(url: url3)
                print("url3:")
            }
            
        }
    }

   //셀 선택시 새창
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailHotelInfoViewController
        
        //send model
        detailViewController.currentHotelModel = allList[indexPath.row]
        
        self.present(detailViewController, animated: true, completion: nil)
        

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
