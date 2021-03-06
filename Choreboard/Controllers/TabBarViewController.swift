//
//  TabBarViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import Foundation
import UIKit
import RealmSwift

class TabBarViewController: UITabBarController {
    let userRealm: Realm
    let householdRealm: Realm
    
    init(userRealm: Realm, householdRealm: Realm) {
        self.userRealm = userRealm
        self.householdRealm = householdRealm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let vc1 = ProfileViewController(userRealm: userRealm, householdRealm: householdRealm)
        //let vc2 = NewHomeViewController(userRealm: userRealm, householdRealm: householdRealm)
        let vc2 = HomeViewController(userRealm: userRealm, householdRealm: householdRealm)
        let vc3 = SettingsViewController(userRealm: userRealm, householdRealm: householdRealm)
        
        vc1.title = "Profile"
        vc2.title = "Home"
        vc3.title = "Settings"
        
        let item1 = UINavigationController(rootViewController: vc1)
        let item2 = UINavigationController(rootViewController: vc2)
        let item3 = UINavigationController(rootViewController: vc3)
        
        item1.navigationBar.prefersLargeTitles = true
        item2.navigationBar.prefersLargeTitles = true
        item3.navigationBar.prefersLargeTitles = true
        
        item1.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        item2.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        item3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        setViewControllers([item1, item2, item3], animated: false)
        
        /* Set default view ot the middle tab */
        self.selectedIndex = 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
