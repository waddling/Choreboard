//
//  ViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/24/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

class MyTabBarController: UITabBarController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set deafult view ot the middle tab */
        self.selectedIndex = 1
        
        /* Color Settings */
        self.tabBar.tintColor = .white                      // Selected item color
        self.tabBar.unselectedItemTintColor = .lightGray    // Unselected item color
        self.tabBar.barTintColor = .blue                    // Background color
    }
    
}
