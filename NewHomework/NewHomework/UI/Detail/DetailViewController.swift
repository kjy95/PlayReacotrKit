//
//  DetailViewController.swift
//  NewHomework
//
//  Created by draak on 03/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Kingfisher

class DetailViewController: UIViewController, ReactorKit.View {
    
    //스크롤뷰
    private let contentsScrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    //이미지뷰
    private let contentImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    //평점레이블
    private let scoreLabel = UILabel()
    
    //제목 레이블
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 3
    }
    
    //가격 레이블
    private let priceLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    private let favoriteToggleButton = UIButton(type: UIButton.ButtonType.custom)
    private let redHeartImage = "ic_favorite_solid".getSVGImage(color: .red, resize: CGSize(width: 35, height: 35))
    private let grayHeartImage = "ic_favorite_line".getSVGImage(color: .darkGray, resize: CGSize(width: 35, height: 35))
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func bind(reactor: DetailViewReactor) {
        
        self.favoriteToggleButton.rx.tap
            .map { return .favoriteButtonTap }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.affiliate }
            .bind { [weak self] (affiliate) in
                guard let self = self else { return }
                self.setAffiliate(affiliate) }
            .disposed(by: self.disposeBag)
    }
}

extension DetailViewController {
    
    private func setAffiliate(_ affiliate: Affiliate) {
        
        self.scoreLabel.attributedText = ("평점: " + String(affiliate.rate)).getAttributedString(font: UIFont.systemFont(ofSize: 20, weight: .bold), color: .darkGray, align: .center)
        self.titleLabel.attributedText = affiliate.name.getAttributedString(font: UIFont.systemFont(ofSize: 25, weight: .bold), color: .darkGray, align: .center)
        self.priceLabel.attributedText = ("₩ " + String(affiliate.price)).getAttributedString(font: UIFont.systemFont(ofSize: 20, weight: .bold), color: .blue, align: .center)
        self.setFavoriteButtonImage(isFavorite: affiliate.favorite)
        
        self.contentImageView.kf.setImage(with: URL(string: affiliate.imagePath))
        self.contentImageView.contentMode = .scaleAspectFill
        
    }
    
    private func setFavoriteButtonImage(isFavorite: Bool) {
        
        if isFavorite {
            self.favoriteToggleButton.setBackgroundImage(self.redHeartImage, for: .normal)
        } else {
            self.favoriteToggleButton.setBackgroundImage(self.grayHeartImage, for: .normal)
        }
        
    }
    
    private func setUI() {
        
        self.title = "상세보기"
        
        //상단 즐겨찾기 토글 버튼
        self.favoriteToggleButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.favoriteToggleButton)
        
        self.view.addSubview(self.contentsScrollView)
        self.contentsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentsScrollView.addSubview(self.contentImageView)
        self.contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        self.view.addSubview(self.scoreLabel)
        self.scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.contentImageView.snp.bottom).offset(20)
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.scoreLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        self.view.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
    }
    
}
