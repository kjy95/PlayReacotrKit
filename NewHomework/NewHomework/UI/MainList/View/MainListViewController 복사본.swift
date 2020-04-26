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

class MainListViewController: UIViewController {
    
    private let mainTableView: UITableView = UITableView()
    private let mainListViewModel = MainListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.bindRx()
        
    }
}

extension MainListViewController {
    
    private func bindRx() {
        
        //테이블뷰 구성
        self.mainTableView.register(MainListViewCell.self, forCellReuseIdentifier: "MainListViewCell")
        self.mainListViewModel.list.asDriver()
            .drive(mainTableView.rx.items(cellIdentifier: "MainListViewCell", cellType: MainListViewCell.self)) { [weak self] (row, data, cell) in
                guard let self = self else { return }
                cell.setCell(infoData: data)
                cell.favoriteToggleButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
                    //셀 우측 즐겨찾기 버튼 선택 액션
                    guard let self = self else { return }
                    self.mainListViewModel.touchFavorite(id: data.id)
                })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: self.disposeBag)
        
        //테이블뷰 선택 액션
        self.mainTableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let detailViewController = DetailViewController().then {
                    $0.reactor = DetailViewReactor(infoData: self.mainListViewModel.list.value[indexPath.row])
                }
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        
        //테이블뷰 자동 더 보기 기능
        self.mainTableView.rx.contentOffset.asDriver()
            .drive(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                if offset.y + self.mainTableView.frame.size.height + 100 > self.mainTableView.contentSize.height {
                    self.mainListViewModel.getList()
                }
                
            })
            .disposed(by: self.disposeBag)
        
    }
    
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
