//
//  TabBarController.swift
//  Hoteltime2
//
//  Created by draak on 15/02/2019.
//  Copyright © 2019 Withinnovation. All rights reserved.
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
            .bind { [weak self] (favoriteTotalCount) in
                guard let self = self else { return }
                if let favoriteListViewController = self.viewControllers?[1] {
                    favoriteListViewController.title = "즐겨찾기(\(favoriteTotalCount))"
                }
            }
            .disposed(by: self.disposeBag)
        
    }
}

extension BaseTabBarController {
    
    private func setUI() {
        
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().backgroundColor = .white
        
        let mainListViewController = MainListViewController()
        mainListViewController.reactor = MainListReactor()
        let mainListNavigationController = UINavigationController(rootViewController: mainListViewController).then {
            $0.navigationBar.topItem?.title = "숙소 리스트"
            $0.title = "숙소 리스트"
            $0.tabBarItem.image = "ic_filter".getSVGImage(resize: CGSize(width: 24, height: 24))
        }
        
        let favoriteListViewController = FavoriteListViewController()
        favoriteListViewController.reactor = FavoriteListReactor()
        let favoriteListNavigationController = UINavigationController(rootViewController: favoriteListViewController).then {
            $0.navigationBar.topItem?.title = "즐겨찾기"
            $0.title = "즐겨찾기"
            $0.tabBarItem.image = "ic_favorite_solid".getSVGImage(resize: CGSize(width: 24, height: 24))
        }
        
        self.viewControllers = [mainListNavigationController, favoriteListNavigationController]
        
    }
    
}
