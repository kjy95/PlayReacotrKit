//
//  FavoriteHotelTableViewCell.swift
//  withinTest
//
//  Created by 김지영 on 16/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit

//MARK: - define protocol
protocol FavoriteHotelTableViewCellDelegate : class {
    // 즐겨찾기 스위치
    func switchFavorite(isOn : Bool, indexPathRow: Int)
    //오름차순, 내림차순
    func sortRateIncrease()
    func sortRateDecrease()
    func sortFavoriteTimeIncrease()
    func sortFavoriteTimeDecrease()
}
class FavoriteHotelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoritedTime: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!

    //delegate
    weak var delegate: FavoriteHotelTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //즐겨찾기 버튼 눌렀을 때
    @IBAction func favoriteSwitch(_ sender: UISwitch) {
        delegate?.switchFavorite(isOn: sender.isOn, indexPathRow: sender.tag)
    }
    
    //rate
    @IBAction func sortRateIncrease(_ sender: Any) {
        delegate?.sortRateIncrease()
    }
    @IBAction func sortRateDecrease(_ sender: Any) {
        delegate?.sortRateDecrease()
    }
    //favorite assign time
    @IBAction func sortFavoriteTimeIncrease(_ sender: Any) {
        delegate?.sortFavoriteTimeIncrease()
    }
    @IBAction func sortFavoriteTimeDecrease(_ sender: Any) {
        delegate?.sortFavoriteTimeDecrease()
    }
    
}
