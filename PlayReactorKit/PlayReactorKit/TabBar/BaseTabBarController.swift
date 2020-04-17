//
//  BaseTabBarController.swift
//  PlayReactorKit
//
//  Created by tori on 17/04/2020.
//  Copyright © 2020 tori. All rights reserved.
//

import RxSwift

class BaseTabBarController: UITabBarController {

    let tabBarViewModel = TabBarViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.set
    }
    
}
