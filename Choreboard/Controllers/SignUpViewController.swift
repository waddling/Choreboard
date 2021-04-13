//
//  SignUpViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 4/12/21.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        let signUpOptions = UIStackView()
        signUpOptions.translatesAutoresizingMaskIntoConstraints = false
        signUpOptions.axis = .vertical
        signUpOptions.alignment = .fill
        signUpOptions.spacing = 10.0
        view.addSubview(signUpOptions)
        
        NSLayoutConstraint.activate([
            signUpOptions.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            signUpOptions.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            signUpOptions.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
        ])
        
        // MARK: Sign In with email
        let emailSignUp = UIButton(type: .custom)
        emailSignUp.translatesAutoresizingMaskIntoConstraints = false
        emailSignUp.setTitle("Sign Up with Email", for: .normal)
        emailSignUp.setAttributedTitle(
            NSAttributedString(
                string: "Sign Up with Email",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            ),
            for: .normal
        )
        emailSignUp.layer.cornerRadius = 5
        emailSignUp.layer.borderWidth = 1
        emailSignUp.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        signUpOptions.addSubview(emailSignUp)
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
