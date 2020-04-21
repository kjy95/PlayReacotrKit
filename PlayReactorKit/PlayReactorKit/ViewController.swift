//
//  ViewController.swift
//  PlayReactorKit
//
//  Created by tori on 17/04/2020.
//  Copyright © 2020 tori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            let tabBarController = BaseTabBarController()
            tabBarController.reactor = TabBarReactor()
            window.rootViewController = tabBarController
        }
    }


}

