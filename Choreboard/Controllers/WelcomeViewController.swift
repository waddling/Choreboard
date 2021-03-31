//
//  WelcomeViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/30/21.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sign In with Apple
        // https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple
        // https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6
        // setupSignInAppleButton()
        
        // Sign In with Google
        // https://developers.google.com/identity/sign-in/ios/start-integrating
        
        // Sign In with email
        
        title = "Choreboard"
        view.backgroundColor = .systemBackground
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
