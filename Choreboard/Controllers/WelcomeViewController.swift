//
//  WelcomeViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/30/21.
//

import UIKit
import RealmSwift
import GoogleSignIn

class WelcomeViewController: UIViewController {
    let emailField = UITextField()
    let passwordField = UITextField()
    let signInButton = UIButton(type: .roundedRect)
    let signUpButton = UIButton(type: .roundedRect)
    let errorLabel = UILabel()
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
        title = "Choreboard"
        view.backgroundColor = .systemBackground
        
        // MARK: Sign In with Apple
        // https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple
        // https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6
        // setupSignInAppleButton()
        
        // MARK: Sign In with Google
        // https://developers.google.com/identity/sign-in/ios/start-integrating
        // https://developers.google.com/identity/sign-in/ios/sign-in
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let GIDSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        GIDSignIn.center = view.center
        
        // Automatically sign in the user.
        // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        
        
        
        
        // Create a view that will automatically lay out the other controls.
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 5.0
        view.addSubview(container)
        
        // Configure the activity indicator.
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        // Set the layout constraints of the container view and the activity indicator.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // This pins the container view to the top and stretches it to fill the parent
            // view horizontally.
            container.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 70),
            container.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -70),
            container.topAnchor.constraint(equalTo: guide.topAnchor, constant: 100),
            // The activity indicator is centered over the rest of the view.
            activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
        ])

        // Add some text at the top of the view to explain what to do.
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.text = "Please enter a email and password."
        container.addArrangedSubview(infoLabel)

        // Configure the email and password text input fields.
        emailField.placeholder = "Username"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        container.addArrangedSubview(emailField)

        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        container.addArrangedSubview(passwordField)

        // Configure the sign in and sign up buttons.
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        container.addArrangedSubview(signInButton)

        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        container.addArrangedSubview(signUpButton)

        // Error messages will be set on the errorLabel.
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
        container.addArrangedSubview(errorLabel)
    }
    
    // Turn on or off the activity indicator.
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            errorLabel.text = ""
        } else {
            activityIndicator.stopAnimating()
        }
        emailField.isEnabled = !loading
        passwordField.isEnabled = !loading
        signInButton.isEnabled = !loading
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
                    self!.errorLabel.text = "Signup failed: \(error!.localizedDescription)"
                    return
                }
                print("Signup successful!")

                // Registering just registers. Now we need to sign in, but we can reuse the existing email and password.
                self!.errorLabel.text = "Signup successful! Signing in..."
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
                    self!.errorLabel.text = "Login failed: \(error.localizedDescription)"
                    return
                case .success(let user):
                    print("Login succeeded!")

                    // Load again while we open the realm.
                    self!.setLoading(true)
                    // Get a configuration to open the synced realm.
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    // Only allow User objects in this partition.
                    configuration.objectTypes = [User.self, Household.self]
                    // Open the realm asynchronously so that it downloads the remote copy before
                    // opening the local copy.
                    Realm.asyncOpen(configuration: configuration) { [weak self](result) in
                        DispatchQueue.main.async {
                            self!.setLoading(false)
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let _):
                                // Go to the list of projects in the user object contained in the user realm.
                                self!.navigationController!.pushViewController(TabBarViewController(), animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
