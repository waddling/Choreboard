//
//  HouseholdSetupViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/29/21.
//

import Foundation
import UIKit
import RealmSwift

class HouseholdSetupViewController: UIViewController {
    let userRealm: Realm
    
    let newHouseholdButton = UIButton(type: .custom)
    let joinHouseholdButton = UIButton(type: .custom)
    
    init(userRealm: Realm) {
        self.userRealm = userRealm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setup"
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonDidClick))
        
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.distribution = .fillProportionally
        container.spacing = 10.0
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 100),
            container.widthAnchor.constraint(equalToConstant: 250),
            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            container.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50)
        ])
        
        newHouseholdButton.addTarget(self, action: #selector(newHouseholdButtonDidClick), for: .touchUpInside)
        newHouseholdButton.translatesAutoresizingMaskIntoConstraints = false
        newHouseholdButton.setAttributedTitle(
            NSAttributedString(
                string: "Start a New Household",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        newHouseholdButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        newHouseholdButton.layer.cornerRadius = 5
        newHouseholdButton.backgroundColor = UIColor(hex: "#6EADE9")
        newHouseholdButton.layer.borderWidth = 1
        newHouseholdButton.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        container.addArrangedSubview(newHouseholdButton)
        
        joinHouseholdButton.addTarget(self, action: #selector(joinHouseholdButtonDidClick), for: .touchUpInside)
        joinHouseholdButton.translatesAutoresizingMaskIntoConstraints = false
        joinHouseholdButton.setAttributedTitle(
            NSAttributedString(
                string: "Join a Household",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        joinHouseholdButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        joinHouseholdButton.layer.cornerRadius = 5
        joinHouseholdButton.backgroundColor = UIColor(hex: "#6EADE9")
        joinHouseholdButton.layer.borderWidth = 1
        joinHouseholdButton.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        container.addArrangedSubview(joinHouseholdButton)
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
    
    @objc func newHouseholdButtonDidClick() {
        self.navigationController?.pushViewController(NewHouseholdSetupViewController(userRealm: self.userRealm), animated: true)
    }
    
    @objc func joinHouseholdButtonDidClick() {
        self.navigationController?.pushViewController(JoinHouseholdSetupViewController(userRealm: self.userRealm), animated: true)
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
