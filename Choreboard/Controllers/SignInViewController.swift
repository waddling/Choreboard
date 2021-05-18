//
//  SignInViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/14/21.
//

import UIKit
// import GoogleSignIn

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let signInOptions = UIStackView()
        signInOptions.translatesAutoresizingMaskIntoConstraints = false
        signInOptions.axis = .vertical
        signInOptions.alignment = .fill
        signInOptions.spacing = 10.0
        view.addSubview(signInOptions)
        NSLayoutConstraint.activate([
            signInOptions.heightAnchor.constraint(equalToConstant: 60),
            signInOptions.widthAnchor.constraint(equalToConstant: 250),
            signInOptions.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            signInOptions.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        // MARK: Sign In with Apple
        // https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple
        // https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6
        // setupSignInAppleButton()
        
        // MARK: Sign In with Google
        // https://developers.google.com/identity/sign-in/ios/start-integrating
        // https://developers.google.com/identity/sign-in/ios/sign-in
        // GIDSignIn.sharedInstance()?.presentingViewController = self
        // let GIDSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        
        // MARK: Sign In with Email
        let emailSignIn = UIButton(type: .custom)
        emailSignIn.addTarget(self, action: #selector(pushEmailSignIn), for: .touchUpInside)
        
        emailSignIn.translatesAutoresizingMaskIntoConstraints = false
        emailSignIn.setAttributedTitle(
            NSAttributedString(
                string: "Sign In with Email",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        emailSignIn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        emailSignIn.layer.cornerRadius = 5
        emailSignIn.backgroundColor = UIColor(hex: "#6EADE9")
        emailSignIn.layer.borderWidth = 1
        emailSignIn.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        signInOptions.addArrangedSubview(emailSignIn)
    }
    
    @objc func pushEmailSignIn(_ sender: Any) {
        self.navigationController!.pushViewController(EmailSignInViewController(), animated: true)
        // self.present(EmailSignUpViewController(), animated: true, completion: nil)
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
