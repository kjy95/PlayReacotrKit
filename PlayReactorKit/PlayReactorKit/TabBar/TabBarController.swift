//
//  BaseTabBarController.swift
//  PlayReactorKit
//
//  Created by tori on 17/04/2020.
//  Copyright © 2020 tori. All rights reserved.
//

import RxSwift
import ReactorKit

class BaseTabBarController: UITabBarController, ReactorKit.View {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func bind(reactor: TabBarReactor) {
        reactor.state
            .map { $0.favoriteCount }
            .bind { [weak self] (favoriteCount) in
                guard let self = self else { return }
                if let favoriteListViewController = self.viewControllers?[1] {
                    favoriteListViewController.title = "즐겨찾기(\(favoriteCount))"
                }
        }
        .disposed(by: self.disposeBag)
    }
}

extension BaseTabBarController {
    func setUI() {
        
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().backgroundColor = .white
        
        let mainListViewController = MainListViewController()
//        mainListViewController.reactor = MainListReactor()
        
        let mainListNavigationController = UINavigationController(rootViewController: mainListViewController)
       
        let favoriteListViewController = FavoriteListViewController()
//        favoriteListViewController.reactor = FavoriteListReactor()
        let favoriteListNavigationController = UINavigationController(rootViewController: favoriteListViewController)
        
        self.viewControllers = [mainListNavigationController, favoriteListNavigationController]
    }
}
