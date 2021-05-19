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
    let userRealm: Realm
    var notificationToken: NotificationToken?
    var objectNotificationToken: NotificationToken?
    var userData: User?
    
    let joinHouseholdPrompt = UILabel()
    let joinHouseholdPromptInfo = UILabel()
    let householdIDField = UITextField()
    let joinHouseholdSubmitButton = UIButton(type: .custom)
    
    var householdID: String? {
        get {
            return householdIDField.text
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
        
        view.addSubview(joinHouseholdPrompt)
        view.addSubview(joinHouseholdPromptInfo)
        view.addSubview(householdIDField)
        view.addSubview(joinHouseholdSubmitButton)
        
        joinHouseholdPrompt.translatesAutoresizingMaskIntoConstraints = false
        joinHouseholdPrompt.numberOfLines = 0
        joinHouseholdPrompt.textAlignment = .center
        joinHouseholdPrompt.font = UIFont(name: "Lato-Regular", size: 36)!
        joinHouseholdPrompt.text = "Enter the ID of the household you would like to join:"
        NSLayoutConstraint.activate([
            joinHouseholdPrompt.widthAnchor.constraint(equalToConstant: 320),
            joinHouseholdPrompt.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            joinHouseholdPrompt.bottomAnchor.constraint(equalTo: joinHouseholdPromptInfo.topAnchor, constant: -15)
        ])
        
        joinHouseholdPromptInfo.translatesAutoresizingMaskIntoConstraints = false
        joinHouseholdPromptInfo.numberOfLines = 0
        joinHouseholdPromptInfo.textAlignment =  .center
        joinHouseholdPromptInfo.font = UIFont(name: "Lato-Regular", size: 20)!
        joinHouseholdPromptInfo.textColor = .systemGray
        joinHouseholdPromptInfo.text = "(This ID can be found in the \"My User Page\" of an existing member of the household.)"
        NSLayoutConstraint.activate([
            joinHouseholdPromptInfo.widthAnchor.constraint(equalToConstant: 270),
            joinHouseholdPromptInfo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            joinHouseholdPromptInfo.bottomAnchor.constraint(equalTo: householdIDField.topAnchor, constant: -40)
        ])
        
        householdIDField.translatesAutoresizingMaskIntoConstraints = false
        householdIDField.placeholder = "aaa111bbb222ccc333ddd444, e.g."
        householdIDField.borderStyle = .roundedRect
        householdIDField.autocorrectionType = .no
        householdIDField.autocapitalizationType = .words
        NSLayoutConstraint.activate([
            householdIDField.widthAnchor.constraint(equalToConstant: 250),
            householdIDField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            householdIDField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50)
        ])
        
        joinHouseholdSubmitButton.isEnabled = true
        joinHouseholdSubmitButton.addTarget(self, action: #selector(joinHouseholdSubmitButtonDidClick), for: .touchUpInside)
        joinHouseholdSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        joinHouseholdSubmitButton.setAttributedTitle(
            NSAttributedString(
                string: "Join",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        joinHouseholdSubmitButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        joinHouseholdSubmitButton.layer.cornerRadius = 5
        joinHouseholdSubmitButton.backgroundColor = UIColor(hex: "#6EADE9")
        joinHouseholdSubmitButton.layer.borderWidth = 1
        joinHouseholdSubmitButton.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        NSLayoutConstraint.activate([
            joinHouseholdSubmitButton.widthAnchor.constraint(equalToConstant: 150),
            joinHouseholdSubmitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            joinHouseholdSubmitButton.topAnchor.constraint(equalTo: householdIDField.bottomAnchor, constant: 40)
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

    @objc func joinHouseholdSubmitButtonDidClick() {
        print("\(userData!)")
        objectNotificationToken = userData!.observe { change in
            switch change {
            case .change(_, _):
                print("Changes were made.")
            case .error(let error):
                print("An error occurred: \(error)")
            case .deleted:
                print("The object was deleted.")
            }
        }
        
        if householdID!.isEmpty {
            let alertController = UIAlertController(title: "Please enter a ID.", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("\(userData!)")
            
            let user = app.currentUser!
            user.functions.addToHousehold([AnyBSON(householdID!)]) { [self](result, error) in
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
                            Realm.asyncOpen(configuration: user.configuration(partitionValue: "household=\(householdID!)")) { [weak self] (result) in
                                switch result {
                                case .failure(let error):
                                    
                                    fatalError("Failed to open realm: \(error)")
                                case .success(let realm):
                                    try! userRealm.write {
                                        userData!.firstTimeSetup = false
                                    }
                                    
                                    let household = realm.objects(Household.self).first!
                                    
                                    try! realm.write {
                                        household.members.append(Member(user: userData!, household: household))
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
