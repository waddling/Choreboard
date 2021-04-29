//
//  SetupViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/17/21.
//

import Foundation
import UIKit
import RealmSwift

class SetupViewController: UIViewController {
    let userRealm: Realm
    var notificationToken: NotificationToken?
    var userData: User?
    
    let namePrompt = UILabel()
    let namePromptInfo = UILabel()
    let nameField = UITextField()
    let nameSubmitButton = UIButton()
    let newHouseholdButton = UIButton()
    let joinHouseholdButton = UIButton()
    let householdNamePrompt = UILabel()
    let householdNameField = UITextField()
    
    var name: String? {
        get {
            return nameField.text
        }
    }
    
    init(userRealm: Realm) {
        self.userRealm = userRealm
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setup"
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonDidClick))
        
        namePrompt.translatesAutoresizingMaskIntoConstraints = false
        namePrompt.numberOfLines = 2
        namePrompt.textAlignment = .center
        namePrompt.font = UIFont(name: "Lato-Regular", size: 36)!
        namePrompt.text = "Hello.\nWhat is your name?"
        view.addSubview(namePrompt)
        NSLayoutConstraint.activate([
            namePrompt.widthAnchor.constraint(equalToConstant: 320),
            namePrompt.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            namePrompt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        namePromptInfo.translatesAutoresizingMaskIntoConstraints = false
        namePromptInfo.numberOfLines = 0
        namePromptInfo.textAlignment =  .center
        namePromptInfo.font = UIFont(name: "Lato-Regular", size: 20)!
        namePromptInfo.textColor = .systemGray
        namePromptInfo.text = "(This is the name that will be visible to others.)"
        view.addSubview(namePromptInfo)
        NSLayoutConstraint.activate([
            namePromptInfo.widthAnchor.constraint(equalToConstant: 250),
            namePromptInfo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            namePromptInfo.topAnchor.constraint(equalTo: namePrompt.bottomAnchor, constant: 15)
        ])
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = "Name"
        nameField.borderStyle = .roundedRect
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .words
        view.addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.widthAnchor.constraint(equalToConstant: 250),
            nameField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: namePromptInfo.bottomAnchor, constant: 40)
        ])
        
        nameSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @objc func signOutButtonDidClick() {
        let alertController = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {
            _ -> Void in
            print("Signing out...")
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    print("Logged out!")
                    self.navigationController?.popViewController(animated: true)
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
