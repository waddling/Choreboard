//
//  NameSetupViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/17/21.
//

import Foundation
import UIKit
import RealmSwift

class NameSetupViewController: UIViewController {
    let userRealm: Realm
    var notificationToken: NotificationToken?
    var objectNotificationToken: NotificationToken?
    var userData: User?
    
    let namePrompt = UILabel()
    let namePromptInfo = UILabel()
    let nameField = UITextField()
    let nameSubmitButton = UIButton(type: .custom)
    
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
        self.userData = usersInRealm.first ?? User(name: "")

        notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
            self?.userData = usersInRealm.first
            print("CHANGE: \(self?.userData ?? User(name: "NIL"))")
        }
        
        print("INIT: \(userData!)")
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonDidClick))
        
        view.addSubview(nameField)
        view.addSubview(namePromptInfo)
        view.addSubview(namePrompt)
        view.addSubview(nameSubmitButton)
        
        namePrompt.translatesAutoresizingMaskIntoConstraints = false
        namePrompt.numberOfLines = 2
        namePrompt.textAlignment = .center
        namePrompt.font = UIFont(name: "Lato-Regular", size: 36)!
        namePrompt.text = "Hello.\nWhat is your name?"
        NSLayoutConstraint.activate([
            namePrompt.widthAnchor.constraint(equalToConstant: 320),
            namePrompt.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            namePrompt.bottomAnchor.constraint(equalTo: namePromptInfo.topAnchor, constant: -15)
        ])
        
        namePromptInfo.translatesAutoresizingMaskIntoConstraints = false
        namePromptInfo.numberOfLines = 0
        namePromptInfo.textAlignment =  .center
        namePromptInfo.font = UIFont(name: "Lato-Regular", size: 20)!
        namePromptInfo.textColor = .systemGray
        namePromptInfo.text = "(This is the name that will be visible to others.)"
        NSLayoutConstraint.activate([
            namePromptInfo.widthAnchor.constraint(equalToConstant: 250),
            namePromptInfo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            namePromptInfo.bottomAnchor.constraint(equalTo: nameField.topAnchor, constant: -40)
        ])
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = "Jane Doe, e.g."
        nameField.borderStyle = .roundedRect
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .words
        NSLayoutConstraint.activate([
            nameField.widthAnchor.constraint(equalToConstant: 250),
            nameField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50)
        ])
        
        nameSubmitButton.isEnabled = true
        nameSubmitButton.addTarget(self, action: #selector(nameSubmitButtonDidClick), for: .touchUpInside)
        nameSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        nameSubmitButton.setAttributedTitle(
            NSAttributedString(
                string: "Next",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        nameSubmitButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        nameSubmitButton.layer.cornerRadius = 5
        nameSubmitButton.backgroundColor = UIColor(hex: "#6EADE9")
        nameSubmitButton.layer.borderWidth = 1
        nameSubmitButton.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        NSLayoutConstraint.activate([
            nameSubmitButton.widthAnchor.constraint(equalToConstant: 150),
            nameSubmitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameSubmitButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 40)
        ])
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
    
    @objc func nameSubmitButtonDidClick() {
        print("\(userData!)")
        objectNotificationToken = userData!.observe { change in
            switch change {
            case .change(_, _):
                self.navigationController!.pushViewController(HouseholdSetupViewController(userRealm: self.userRealm), animated: true)
                self.notificationToken?.invalidate()
                self.objectNotificationToken?.invalidate()
            case .error(let error):
                print("An error occurred: \(error)")
            case .deleted:
                print("The object was deleted.")
            }
        }
        
        if name!.isEmpty {
            let alertController = UIAlertController(title: "Please enter a name.", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("\(userData!)")
            
            try! self.userRealm.write {
                userData!.name = name!
            }
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
