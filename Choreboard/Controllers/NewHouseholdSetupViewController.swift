//
//  NewHouseholdSetupViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/29/21.
//

import Foundation
import UIKit
import RealmSwift

class NewHouseholdSetupViewController: UIViewController {
    let userRealm: Realm
    var notificationToken: NotificationToken?
    var objectNotificationToken: NotificationToken?
    var userData: User?
    
    let householdNamePrompt = UILabel()
    let householdNameField = UITextField()
    let householdNameSubmitButton = UIButton(type: .custom)
    
    var householdName: String? {
        get {
            return householdNameField.text
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
        objectNotificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setup"
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonDidClick))
        
        view.addSubview(householdNamePrompt)
        view.addSubview(householdNameField)
        view.addSubview(householdNameSubmitButton)
        
        householdNamePrompt.translatesAutoresizingMaskIntoConstraints = false
        householdNamePrompt.numberOfLines = 3
        householdNamePrompt.textAlignment = .center
        householdNamePrompt.font = UIFont(name: "Lato-Regular", size: 36)!
        householdNamePrompt.text = "What would you like to call your Household?"
        NSLayoutConstraint.activate([
            householdNamePrompt.widthAnchor.constraint(equalToConstant: 320),
            householdNamePrompt.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            householdNamePrompt.bottomAnchor.constraint(equalTo: householdNameField.topAnchor, constant: -40)
        ])
        
        householdNameField.translatesAutoresizingMaskIntoConstraints = false
        householdNameField.placeholder = "The Best House!, e.g."
        householdNameField.borderStyle = .roundedRect
        householdNameField.autocorrectionType = .no
        householdNameField.autocapitalizationType = .words
        NSLayoutConstraint.activate([
            householdNameField.widthAnchor.constraint(equalToConstant: 250),
            householdNameField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            householdNameField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50)
        ])
        
        householdNameSubmitButton.isEnabled = true
        householdNameSubmitButton.addTarget(self, action: #selector(householdNameSubmitButtonDidClick), for: .touchUpInside)
        householdNameSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        householdNameSubmitButton.setAttributedTitle(
            NSAttributedString(
                string: "Create",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        householdNameSubmitButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        householdNameSubmitButton.layer.cornerRadius = 5
        householdNameSubmitButton.backgroundColor = UIColor(hex: "#6EADE9")
        householdNameSubmitButton.layer.borderWidth = 1
        householdNameSubmitButton.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        NSLayoutConstraint.activate([
            householdNameSubmitButton.widthAnchor.constraint(equalToConstant: 150),
            householdNameSubmitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            householdNameSubmitButton.topAnchor.constraint(equalTo: householdNameField.bottomAnchor, constant: 40)
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

    @objc func householdNameSubmitButtonDidClick() {
        objectNotificationToken = userData!.observe { change in
            switch change {
            case .change(_, _):
                print("Changes were made.")
                // self.navigationController!.pushViewController(HouseholdSetupViewController(realm: self.realm), animated: true)
            case .error(let error):
                print("An error occurred: \(error)")
            case .deleted:
                print("The object was deleted.")
            }
        }
        
        if householdName!.isEmpty {
            let alertController = UIAlertController(title: "Please enter a name.", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let household = Household(name: householdName!)
            household._partition = "household=\(household._id)"
            household.members.append(Member(user: userData!, household: household))
            print("\(household)")
            
            let user = app.currentUser!
            user.functions.createNewHousehold([AnyBSON(household._id)]) { [self](result, error) in
                DispatchQueue.main.async {
                    var errorMessage: String?

                    if error != nil {
                        errorMessage = error!.localizedDescription
                    } else if let resultDocument = result?.documentValue {
                        errorMessage = resultDocument["error"]??.stringValue
                    } else {
                        errorMessage = "Unexpected result returned from server"
                    }

                    guard errorMessage == nil else {
                        print("Could not create new household: \(errorMessage!)")
                        let alertController = UIAlertController(
                            title: "Error",
                            message: errorMessage!,
                            preferredStyle: .alert
                        )

                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                        present(alertController, animated: true)
                        return
                    }
                }
            }
            
            user.functions.addToHousehold([AnyBSON(household._id)]) { [self](result, error) in
                DispatchQueue.main.async {
                    var errorMessage: String?

                    if error != nil {
                        errorMessage = error!.localizedDescription
                    } else if let resultDocument = result?.documentValue {
                        errorMessage = resultDocument["error"]??.stringValue
                    } else {
                        errorMessage = "Unexpected result returned from server"
                    }

                    guard errorMessage == nil else {
                        print("Could not add user to household: \(errorMessage!)")
                        let alertController = UIAlertController(
                            title: "Error",
                            message: errorMessage!,
                            preferredStyle: .alert
                        )

                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                        present(alertController, animated: true)
                        return
                    }

                    print("Successfully added user to household")
                    
                    let user = app.currentUser!
                    
                    user.refreshCustomData { (result) in
                        switch result {
                        case .failure(let error):
                            print("Failed to refresh custom data: \(error.localizedDescription)")
                        case .success(let customData):
                            // favoriteColor was set on the custom data.
                            print("Refreshed: \(customData)")
                            Realm.asyncOpen(configuration: user.configuration(partitionValue: household._partition)) { [weak self] (result) in
                                switch result {
                                case .failure(let error):
                                    
                                    fatalError("Failed to open realm: \(error)")
                                case .success(let realm):
                                    try! userRealm.write {
                                        userData!.firstTimeSetup = false
                                    }
                                    
                                    try! realm.write {
                                        realm.add(household.self, update: .modified)
                                    }
                                    self!.navigationController!.pushViewController(TabBarViewController(userRealm: userRealm, householdRealm: realm), animated: true)
                                }
                            }
                        }
                    }
                }
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
