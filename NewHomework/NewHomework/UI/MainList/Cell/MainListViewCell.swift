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
import ReactorKit

class MainListViewCell: UITableViewCell, ReactorKit.View {
    
    private var thumbnailImageView = UIImageView()
    private var titleLabel = UILabel()
    private var scoreLabel = UILabel()
    private var favoriteImageView = UIImageView()
    private var favoriteToggleButton = UIButton()
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
    
    func bind(reactor: MainListViewCellReactor) {
        
        reactor.state.asObservable().bind { [weak self] (state) in
            guard let self = self else { return }
            self.setCell(affiliate: state.affiliate)
        }.disposed(by: self.disposeBag)
        
        self.favoriteToggleButton.rx.tap
            .map { Reactor.Action.favoriteButtonTap }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
    }
    
}


extension MainListViewCell {
    
    private func setCell(affiliate: Affiliate) {
        
        self.titleLabel.attributedText = "\(affiliate.name)".getAttributedString(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        self.scoreLabel.attributedText = "평점: \(affiliate.rate)".getAttributedString(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .black)
        self.thumbnailImageView.kf.setImage(with: URL(string: affiliate.thumbnailPath))
        
        if affiliate.favorite {
            self.favoriteImageView.image = "ic_favorite_solid".getSVGImage(color: .red, resize: CGSize(width: 30, height: 30))
        } else {
            self.favoriteImageView.image = "ic_favorite_line".getSVGImage(color: .darkGray, resize: CGSize(width: 30, height: 30))
        }
        
    }
    
    private func setUI() {
        self.selectionStyle = .none

        //썸네일 이미지
        self.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.backgroundColor = .gray
        self.thumbnailImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        //즐겨찾기 이미지(하트)
        self.addSubview(self.favoriteImageView)
        self.favoriteImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        //즐겨찾기 토글 버튼
        self.addSubview(self.favoriteToggleButton)
        self.favoriteToggleButton.snp.makeConstraints { make in
            make.center.equalTo(self.favoriteImageView)
            make.height.equalTo(80)
            make.width.equalTo(60)
        }
        
        //제목
        self.addSubview(self.titleLabel)
        self.titleLabel.numberOfLines = 2
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.thumbnailImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalTo(self.favoriteImageView.snp.left).offset(-10)
        }
        
        //평점
        self.addSubview(self.scoreLabel)
        self.scoreLabel.snp.makeConstraints { make in
            make.left.equalTo(self.thumbnailImageView.snp.right).offset(10)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.right.equalTo(self.favoriteImageView.snp.left).offset(-10)
        }
    }
    
}
