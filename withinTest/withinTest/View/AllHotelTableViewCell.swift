//
//  AllHotelTableViewCell.swift
//  withinTest
//
//  Created by 김지영 on 12/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit

//MARK: - define protocol
protocol AllHotelTableViewCellDelegate : class {
    // 즐겨찾기 스위치
    func switchFavorite(isOn : Bool, indexPathRow: Int)
}

class AllHotelTableViewCell: UITableViewCell {
    //MARK: - Define value
    
    //UI 
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel! 
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    //delegate
    weak var delegate: AllHotelTableViewCellDelegate?
    
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
}
