//
//  WelcomeViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/30/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choreboard"
        view.backgroundColor = .systemBackground
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let logo = UIImage(named: "choreboard-logo.png")
        let logoView = UIImageView(image: logo)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalToConstant: 250),
            logoView.widthAnchor.constraint(equalToConstant: 250),
            logoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.textAlignment = .center
        logoLabel.font = UIFont(name: "Quicksand-SemiBold", size: 32)!
        logoLabel.text = "C H O R E B O A R D"
        view.addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            logoLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 15)
        ])
        
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
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
        
        let signUp = UIButton(type: .custom)
        signUp.addTarget(self, action: #selector(pushSignUp), for: .touchUpInside)
        
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.setAttributedTitle(
            NSAttributedString(
                string: "Sign Up",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        signUp.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        signUp.layer.cornerRadius = 5
        signUp.backgroundColor = UIColor(hex: "#6EADE9")
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        container.addArrangedSubview(signUp)
        
        let signIn = UIButton(type: .custom)
        signIn.addTarget(self, action: #selector(pushSignIn), for: .touchUpInside)
        
        signIn.translatesAutoresizingMaskIntoConstraints = false
        signIn.setAttributedTitle(
            NSAttributedString(
                string: "Sign In",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            ),
            for: .normal
        )
        signIn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        signIn.layer.cornerRadius = 5
        signIn.backgroundColor = UIColor(hex: "#6EADE9")
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor(hex: "#6EADE9")!.cgColor
        container.addArrangedSubview(signIn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func pushSignUp(_ sender: Any) {
        self.navigationController!.pushViewController(SignUpViewController(), animated: true)
        // self.present(EmailSignUpViewController(), animated: true, completion: nil)
    }
    
    @objc func pushSignIn(_ sender: Any) {
        self.navigationController!.pushViewController(SignInViewController(), animated: true)
        // self.present(EmailSignUpViewController(), animated: true, completion: nil)
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
