//
//  FavoriteListViewCell.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import SnapKit
import Then
import Kingfisher
import RxSwift


class FavoriteListViewCell: UITableViewCell {
    
    var thumbnailImageView = UIImageView()
    var titleLabel = UILabel()
    var scoreLabel = UILabel()
    var favoriteAddedDateLabel = UILabel()
    var favoriteImageView = UIImageView()
    var favoriteToggleButton = UIButton()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
//    func setCellData(_ data: InfoData, dd, ddee) {
    func setCell(affiliate: Affiliate) {
        
        self.titleLabel.attributedText = "\(affiliate.name)".getAttributedString(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        self.scoreLabel.attributedText = "평점: \(affiliate.rate)".getAttributedString(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        self.thumbnailImageView.kf.setImage(with: URL(string: affiliate.thumbnailPath))
        
        if affiliate.favorite {
            self.favoriteImageView.image = "ic_favorite_solid".getSVGImage(color: .red, resize: CGSize(width: 30, height: 30))
        } else {
            self.favoriteImageView.image = "ic_favorite_line".getSVGImage(color: .darkGray, resize: CGSize(width: 30, height: 30))
        }
        
        self.favoriteAddedDateLabel.attributedText = "추가한 시간:\n\(affiliate.savedDate)".getAttributedString(font: UIFont.systemFont(ofSize: 13, weight: .bold), color: .black)
        
    }
}


extension FavoriteListViewCell {
    
    private func setUI() {
        self.selectionStyle = .none
        
        //셀 이미지
        self.thumbnailImageView.do { imageView in
            self.addSubview(imageView)
            imageView.backgroundColor = .gray
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(120)
                make.width.equalTo(180)
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
                make.height.equalTo(120)
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
                make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
                make.right.equalTo(self.favoriteImageView.snp.left).offset(-10)
            }
        }
        
        //즐겨찾기 추가 날짜
        self.favoriteAddedDateLabel.do { label in
            self.addSubview(label)
            label.numberOfLines = 2
            label.snp.makeConstraints { make in
                make.left.equalTo(self.thumbnailImageView.snp.right).offset(10)
                make.top.equalTo(self.scoreLabel.snp.bottom).offset(5)
                make.right.equalTo(self.favoriteImageView.snp.left).offset(-10)
            }
        }
        
        
    }
    
}
