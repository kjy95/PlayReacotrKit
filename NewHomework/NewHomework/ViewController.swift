//
//  ViewController.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
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

