//
//  AddChoreViewController.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/26/21.
//

import UIKit

class AddChoreViewController: UIViewController {
    
    // Dependency Injection: required to access HomeViewCOntroller methods and vars
    private let home: HomeViewController
    init(home: HomeViewController) {
        self.home = home
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleField: UITextField = {
       let field = UITextField()
        field.placeholder = "Chore title..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        // field.autocapitalizationType = .none
        // field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    /*
     TODO: Add the "Assign to..." section as a dropdown menu
     Tutorial: https://www.youtube.com/watch?v=-tpJMQRSl_o&ab_channel=iOSAcademy
     */
    
    private let pointsField: UITextField = {
       let field = UITextField()
        field.placeholder = "Points..."
        field.returnKeyType = .next
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        // field.autocapitalizationType = .none
        // field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let submitButton: UIButton = {
       let button = UIButton()
        button.setTitle("Add Chore", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.backgroundColor = color.UIColorFromRGB(rgbValue: 0xB3D6C6)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Add Chore"
        view.backgroundColor = .systemBackground
        
        // Add button target
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        titleField.delegate = self
        pointsField.delegate = self
        
        // Add subviews
        view.addSubview(titleField)
        view.addSubview(pointsField)
        view.addSubview(submitButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Position frames
        titleField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+10, width: view.frame.size.width-40, height: 52)
        pointsField.frame = CGRect(x: 20, y: titleField.frame.maxY+10, width: view.frame.size.width-40, height: 52)
        submitButton.frame = CGRect(x: 20, y: pointsField.frame.maxY+10, width: view.frame.size.width-40, height: 52)
    }
    
    @objc private func didTapSubmit() {
        // Dismiss keyboard for all fields
        titleField.resignFirstResponder()
        pointsField.resignFirstResponder()
        
        // Get content of all fields
        guard let title = titleField.text, !title.isEmpty,
              let points = pointsField.text, !points.isEmpty
              else {
                return
              }
        
        // Print inputted data
        print("Title: ", title)
        print("Points: ", points)
        
        // Process data, create new chore from input
        let chore = Chore(partition: "part",
                          title: title,
                          createdBy: User(name: "Joe Delle Donne"),
                          assignedTo: User(name: "Joe Delle Donne"),
                          dueDate: Date(),
                          repeating: false,
                          points: Int(points) ?? 0,
                          status: "incomplete")
        home.choresList.append(chore)
        home.reloadSections()
        
        // Navigate back to Home Controller when done
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension AddChoreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Outline chain of where the 'next' button should go in form
        if textField == titleField {
            pointsField.becomeFirstResponder()
        } else {
            didTapSubmit()
        }
        return true
    }
}
