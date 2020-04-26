//
//  MainListViewController.swift
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

class MainListViewController: UIViewController, ReactorKit.View {
    
    private let mainTableView: UITableView = UITableView()
    var disposeBag = DisposeBag()
    
    func bind(reactor: MainListReactor) {
        
        self.mainTableView.register(MainListViewCell.self, forCellReuseIdentifier: "MainListViewCell")
        reactor.state.map { $0.affiliates }
            .bind(to: self.mainTableView.rx.items(cellIdentifier: "MainListViewCell", cellType: MainListViewCell.self)) { (row, affiliate, cell) in
                cell.reactor = MainListViewCellReactor(affiliate: affiliate)
        }
        .disposed(by: self.disposeBag)
        
        //뷰 로드되면 리액터 이니셜라이즈 호출
        self.rx.viewDidLoad
            .map { [weak self] _ in
                guard let self = self else { return Reactor.Action.initialize }
                self.setUI()
                return Reactor.Action.initialize }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //테이블뷰 선택 액션
        self.mainTableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self, weak reactor] indexPath in
                guard let self = self, let reactor = reactor else { return }
                let detailViewController = DetailViewController().then {
                    if let targetAffiliate = reactor.currentState.affiliates[safe: indexPath.row] {
                        $0.reactor = DetailViewReactor(affiliate: targetAffiliate)
                    }
                }
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        //테이블뷰 자동 더 보기 기능
        self.mainTableView.rx.contentOffset
            .filter { [weak self] offset in
                guard let self = self else { return false }
                guard self.mainTableView.frame.height > 0 else { return false }
                return offset.y + self.mainTableView.frame.size.height + 100 > self.mainTableView.contentSize.height }
            .map { _ in MainListReactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
    }
}

extension MainListViewController {
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        self.mainTableView.do { tableView in
            self.view.addSubview(tableView)
            tableView.rowHeight = 100
            tableView.separatorInset.left = 0
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
    }
    
}
