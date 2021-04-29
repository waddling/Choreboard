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
            signUpOptions.heightAnchor.constraint(equalToConstant: 60),
            signUpOptions.widthAnchor.constraint(equalToConstant: 250),
            signUpOptions.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            signUpOptions.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        // MARK: Sign Up with Email
        let emailSignUp = UIButton(type: .custom)
        emailSignUp.addTarget(self, action: #selector(pushEmailSignUp), for: .touchUpInside)
        
        emailSignUp.translatesAutoresizingMaskIntoConstraints = false
        emailSignUp.setAttributedTitle(
            NSAttributedString(
                string: "Sign Up with Email",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        emailSignUp.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        emailSignUp.layer.cornerRadius = 5
        emailSignUp.backgroundColor = UIColor(hex: "#6EADE9")
        emailSignUp.layer.borderWidth = 1
        emailSignUp.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        signUpOptions.addArrangedSubview(emailSignUp)
    }
    
    @objc func pushEmailSignUp(_ sender: Any) {
        self.navigationController!.pushViewController(EmailSignUpViewController(), animated: true)
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
