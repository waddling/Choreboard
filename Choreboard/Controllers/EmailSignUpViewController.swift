//
//  EmailSignUpViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/13/21.
//

import UIKit
import RealmSwift

class EmailSignUpViewController: UIViewController {
    let emailField = UITextField()
    let passwordField = UITextField()
    let signUpButton = UIButton(type: .custom)
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var email: String? {
        get {
            return emailField.text
        }
    }
    
    var password: String? {
        get {
            return passwordField.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Email"
        view.backgroundColor = .systemBackground
        
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.distribution = .fillProportionally
        container.spacing = 10.0
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 150),
            container.widthAnchor.constraint(equalToConstant: 250),
            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        container.addArrangedSubview(emailField)
        
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        container.addArrangedSubview(passwordField)
        
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setAttributedTitle(
            NSAttributedString(
                string: "Sign Up",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        signUpButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        signUpButton.layer.cornerRadius = 5
        signUpButton.backgroundColor = UIColor(hex: "#6EADE9")
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        container.addArrangedSubview(signUpButton)
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailField.isEnabled = !loading
        passwordField.isEnabled = !loading
        signUpButton.isEnabled = !loading
    }
    
    @objc func signUp() {
        setLoading(true)
        app.emailPasswordAuth.registerUser(email: email!, password: password!, completion: { [weak self](error) in
            // Completion handlers are not necessarily called on the UI thread.
            // This call to DispatchQueue.main.async ensures that any changes to the UI,
            // namely disabling the loading indicator and navigating to the next page,
            // are handled on the UI thread:
            DispatchQueue.main.async {
                self!.setLoading(false)
                guard error == nil else {
                    print("Signup failed: \(error!)")
                    let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self!.present(alertController, animated: true, completion: nil)
                    return
                }
                print("Signup successful!")

                // Registering just registers. Now we need to sign in, but we can reuse the existing email and password.
                self!.signIn()
            }
        })
    }
    
    @objc func signIn() {
        print("Log in as user: \(email!)")
        setLoading(true)

        app.login(credentials: Credentials.emailPassword(email: email!, password: password!)) { [weak self](result) in
            // Completion handlers are not necessarily called on the UI thread.
            // This call to DispatchQueue.main.async ensures that any changes to the UI,
            // namely disabling the loading indicator and navigating to the next page,
            // are handled on the UI thread:
            DispatchQueue.main.async {
                self!.setLoading(false)
                switch result {
                case .failure(let error):
                    // Auth error: user already exists? Try logging in as that user.
                    print("Login failed: \(error)")
                    let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self!.present(alertController, animated: true, completion: nil)
                    return
                case .success(let user):
                    print("Login succeeded!")
                    print("\(user)")
                    print("\(user.customData)")
            
                    // Load again while we open the realm.
                    self!.setLoading(true)
                    // Get a configuration to open the synced realm.
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    // Only allow User objects in this partition.
                    configuration.objectTypes = [User.self]
                    
                    // Open the realm asynchronously so that it downloads the remote copy before
                    // opening the local copy.
                    Realm.asyncOpen(configuration: configuration) { [weak self](result) in
                        DispatchQueue.main.async {
                            self!.setLoading(false)
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let userRealm):
                                print("Succussfully opened realm: \(userRealm)")
                                if (user.customData["firstTimeSetup"] ?? AnyBSON(true)) == AnyBSON(true) {
                                    print("First Time Setup")
                                    self!.navigationController!.pushViewController(NameSetupViewController(userRealm: userRealm), animated: true)
                                } else {
                                    print("Not First Time Setup")
                                    fatalError("When creating a new account, they should always be taken to the onboarding process.")
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
