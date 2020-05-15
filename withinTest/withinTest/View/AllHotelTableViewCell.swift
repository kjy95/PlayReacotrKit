//
//  AllHotelTableViewCell.swift
//  withinTest
//
//  Created by 김지영 on 12/08/2019.
//  Copyright © 2019 김지영. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

//MARK: - define protocol
protocol AllHotelTableViewCellDelegate : class {
    // 즐겨찾기 스위치
    func switchFavorite(isOn : Bool, indexPathRow: Int)
}

class AllHotelTableViewCell: UITableViewCell, StoryboardView {
    //MARK: - Define value
    
    //UI 
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel! 
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    //MARK: - Define value
    var disposeBag = DisposeBag()
    
    //MARK: - Reactor Binding
    func bind(reactor: AllHotelTableViewCellReactor) {
        
    }
    
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

class AllHotelTableViewCellReactor: Reactor {
    enum Action {
        case favoriteButtonTap
    }
    
    enum Mutation {
        case toggleIsFavorite(Bool)
    }
    
    struct State {
        var hotel: HotelListModel
    }
    
    let initialState: State
    
    init(hotel: HotelListModel) {
        self.initialState = State(hotel: hotel)
        _ = self.state
    }

}
