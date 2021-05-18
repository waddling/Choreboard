//
//  NewHomeViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 5/17/21.
//

import Foundation
import UIKit
import RealmSwift

class NewHomeViewController: UIViewController {

    let userRealm: Realm
    let householdRealm: Realm
    
    var notificationToken: NotificationToken?
    var objectNotificationToken: NotificationToken?
    
    var userData: User?
    
    init(userRealm: Realm, householdRealm: Realm) {
        self.userRealm = userRealm
        self.householdRealm = householdRealm
        
        super.init(nibName: nil, bundle: nil)
        
        // There should only be one user in my realm - that is myself
        let usersInRealm = userRealm.objects(User.self)

        notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
            self?.userData = usersInRealm.first
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        // Always invalidate any notification tokens when you are done with them.
        notificationToken?.invalidate()
        objectNotificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        super.viewDidLoad()

        title = "Home"
        view.backgroundColor = .systemBackground
        
        let households = householdRealm.objects(Household.self)
        let household = households.first
        print("\(household)")
        let testMember = Member(user: userData!, household: household!)
        
        // How to add new chores
        try! householdRealm.write {
            householdRealm.add(Chore(partition: household!._partition, title: "Test", createdBy: testMember, assignedTo: testMember, dueDate: NSDate() as Date, repeating: false, points: 20, status: ChoreStatus.Open.rawValue))
        }
        
        
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
