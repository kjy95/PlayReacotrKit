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

class FavoriteListViewController: UIViewController {
    
    private let favoriteListTableView: UITableView = UITableView()
    private let favoriteListViewModel = FavoriteListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.bindRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func bindRx() {
        
        //테이블뷰 설정
        self.favoriteListTableView.register(FavoriteListViewCell.self, forCellReuseIdentifier: "FavoriteListViewCell")
        self.favoriteListViewModel.list.asDriver()
            .drive(favoriteListTableView.rx.items(cellIdentifier: "FavoriteListViewCell", cellType: FavoriteListViewCell.self)) { [weak self] (row, affiliate, cell) in
                guard let self = self else { return }
                cell.setCell(affiliate: affiliate)
                cell.favoriteToggleButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
                    //셀 우측 즐겨찾기 버튼 선택 액션
                    guard let self  = self else { return }
                    self.favoriteListViewModel.touchFavorite(id: affiliate.id)
                }).disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
        
        //테이블뷰 선택 액션
        self.favoriteListTableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let detailViewController = DetailViewController().then {
                    $0.reactor = DetailViewReactor(affiliate: self.favoriteListViewModel.list.value[indexPath.row])
                }
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }).disposed(by: self.disposeBag)
     
        //정렬 조건 텍스트를 상단 정렬 버튼에 바인딩
        self.favoriteListViewModel.sortRuleText.asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.navigationItem.rightBarButtonItem?.title = text.rawValue
            }).disposed(by: self.disposeBag)
        
        //상단 정렬 버튼 탭 액션
        self.navigationItem.rightBarButtonItem?.rx.tap.asDriver()
            .drive(onNext: { [weak self] button in
                guard let self = self else { return }
                self.favoriteListViewModel.updateFavorite()
            }).disposed(by: self.disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.style = .plain
        
         self.favoriteListTableView.do { tableView in
            self.view.addSubview(tableView)
            tableView.separatorInset.left = 0
            tableView.rowHeight = 120
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

    }
}
