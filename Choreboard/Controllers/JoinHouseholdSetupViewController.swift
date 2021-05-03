//
//  JoinHouseholdSetupViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/29/21.
//

import Foundation
import UIKit
import RealmSwift

class JoinHouseholdSetupViewController: UIViewController {
    let realm: Realm
    var notificationToken: NotificationToken?
    var objectNotificationToken: NotificationToken?
    var userData: User
    
    init(realm: Realm) {
        self.realm = realm
        self.userData = User(name: "")
        
        super.init(nibName: nil, bundle: nil)
        
        // There should only be one user in my realm - that is myself
        let usersInRealm = realm.objects(User.self)

        notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
            self?.userData = usersInRealm.first!
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
        super.viewDidLoad()

        title = "Setup"
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonDidClick))
    }
    
    @objc func signOutButtonDidClick() {
        let alertController = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {
            _ -> Void in
            print("Signing out...")
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    print("Logged out!")
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
