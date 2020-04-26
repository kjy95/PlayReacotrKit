//
//  DetailHotelInfoView.swift
//  withinTest
//
//  Created by 김지영 on 13/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit
//Reacotrkit
import ReactorKit
import RxSwift
/**
 호텔 상세 페이지
 원본 이미지, 제목, 상세정보들을 화면에 표기
 - 즐겨찾기 토글 기능
 */

//MARK: - define protocol
protocol DetailHotelInfoViewDelegate : class {
    // 즐겨찾기 스위치
    func switchFavorite(isOn : Bool)
    // 나가기 버튼
    func exitButton()
}

//호텔 상세 뷰
class DetailHotelInfoView: UIView {
    
    //set reactorkit
    var disposeBag = DisposeBag()
    
    
    //-------------------------------------------------------------
    //MARK: - define value
    //
    
    //UI
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    //delegate
    weak var delegate : DetailHotelInfoViewDelegate?
    
    //hotel info
    var hotelInfo : HotelListModel?
    
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setView(hotelInfo : HotelListModel){
        // 호텔 정보 정의
        self.hotelInfo = hotelInfo
        
        //text
        self.detail.text = hotelInfo.descriptions["subject"] as? String
        self.hotelName.text = hotelInfo.name
        //image
        let url = URL(string: hotelInfo.thumbnail)
        let data = try? Data(contentsOf: url!)
        self.hotelImage.image = UIImage(data: data!)
        //switch
//        self.favoriteSwitch.isOn = hotelInfo.favorite
    }
    
    func switchFavorite(isOn : Bool){
        self.favoriteSwitch.isOn = isOn
    }
    //-------------------------------------------------------------
    //MARK: - action
    //
    
    @IBAction func favorite(_ sender: UISwitch) {
//        delegate?.switchFavorite(isOn : sender.isOn)
    }
    
    @IBAction func exitButton(_ sender: Any) {
        delegate?.exitButton()
    }
}
