//
//  MainListViewCell.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import RxSwift
import SnapKit
import Then
import Kingfisher

class MainListViewCell: UITableViewCell {
    
    var thumbnailImageView = UIImageView()
    var titleLabel = UILabel()
    var scoreLabel = UILabel()
    var favoriteImageView = UIImageView()
    var favoriteToggleButton = UIButton()
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(infoData: InfoData) {
        
        self.titleLabel.attributedText = "\(infoData.name)".getAttributedString(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        self.scoreLabel.attributedText = "평점: \(infoData.rate)".getAttributedString(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        self.thumbnailImageView.kf.setImage(with: URL(string: infoData.thumbnailPath))
        
        if infoData.favorite {
            self.favoriteImageView.image = "ic_favorite_solid".getSVGImage(color: .red, resize: CGSize(width: 30, height: 30))
        } else {
            self.favoriteImageView.image = "ic_favorite_line".getSVGImage(color: .darkGray, resize: CGSize(width: 30, height: 30))
        }
        
    }
    
}


extension MainListViewCell {
    
    private func setUI() {
        self.selectionStyle = .none

        //썸네일 이미지
        self.thumbnailImageView.do { imageView in
            self.addSubview(imageView)
            imageView.backgroundColor = .gray
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(100)
                make.width.equalTo(100)
            }
        }
        
        //즐겨찾기 이미지(하트)
        self.favoriteImageView.do { imageView in
            self.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
                make.width.equalTo(30)
            }
        }
        
        //즐겨찾기 토글 버튼
        self.favoriteToggleButton.do { button in
            self.addSubview(button)
            button.snp.makeConstraints { make in
                make.center.equalTo(self.favoriteImageView)
                make.height.equalTo(80)
                make.width.equalTo(60)
            }
        }
        
        //제목
        self.titleLabel.do { label in
            self.addSubview(label)
            label.numberOfLines = 2
            label.snp.makeConstraints { make in
                make.left.equalTo(self.thumbnailImageView.snp.right).offset(10)
                make.top.equalToSuperview().offset(10)
                make.right.equalTo(self.favoriteImageView.snp.left).offset(-10)
            }
        }
        
        //평점
        self.scoreLabel.do { label in
            self.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(self.thumbnailImageView.snp.right).offset(10)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                make.right.equalTo(self.favoriteImageView.snp.left).offset(-10)
            }
        }
    }
    
}
