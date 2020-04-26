//
//  Ex+Reactor.swift
//  withinTest
//
//  Created by 김지영 on 26/04/2020.
//  Copyright © 2020 김지영. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

extension Reactive where Base : UIViewController {
    internal var viewWillAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
    }
    internal var viewDidLoad: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidLoad))
    }
    internal var viewDidAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidAppear(_:)))
    }
}
