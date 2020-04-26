//
//  FavoriteListViewController.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import ReactorKit

class FavoriteListViewController: UIViewController, ReactorKit.View {
    
    private let favoriteListTableView: UITableView = UITableView().then {
        $0.separatorInset.left = 0
        $0.rowHeight = 120
    }
    
    var disposeBag = DisposeBag()
    
    func bind(reactor: FavoriteListReactor) {
        self.favoriteListTableView.register(FavoriteListViewCell.self, forCellReuseIdentifier: "FavoriteListViewCell")
        reactor.state.map { $0.affiliates }
            .bind(to: self.favoriteListTableView.rx.items(cellIdentifier: "FavoriteListViewCell", cellType: FavoriteListViewCell.self)) { (row, affiliate, cell) in
                cell.reactor = FavoriteListViewCellReactor(affiliate: affiliate) }
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sortRule.rawValue }
            .bind { [weak self] sortRuleText in
                guard let self = self else { return }
                self.navigationItem.rightBarButtonItem?.title = sortRuleText }
            .disposed(by: self.disposeBag)
        
        //네비게이션 아이템 관련 설정은 뷰가 로드된 뒤 UI그리고 나서 리액터의 액션과 연결
        self.rx.viewDidLoad
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.setUI()
                //네비게이션 바 버튼 탭 액션
                self.navigationItem.rightBarButtonItem?.rx.tap
                    .map { Reactor.Action.sortRuleChange }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
        }
        .disposed(by: self.disposeBag)
        
        //뷰가 로드되면 리액터에 initialize 액션 전달
        self.rx.viewDidLoad
            .map { _ in
                return .initialize }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //테이블뷰 선택 액션
        self.favoriteListTableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self, weak reactor] indexPath in
                guard let self = self, let reactor = reactor else { return }
                let detailViewController = DetailViewController().then {
                    
                    $0.reactor = DetailViewReactor(affiliate: reactor.currentState.affiliates[indexPath.row])
                }
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.style = .plain
        
        self.view.addSubview(self.favoriteListTableView)
        self.favoriteListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.left.right.top.equalToSuperview()
//            let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 83
//            make.bottom.equalToSuperview().inset(tabBarHeight)
        }
        
    }
}
