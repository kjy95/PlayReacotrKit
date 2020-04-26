//
//  Reactive+Ex.swift
//  NewHomework
//
//  Created by draak on 18/03/2020.
//  Copyright © 2020 Draak. All rights reserved.
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
