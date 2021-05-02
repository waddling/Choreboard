//
//  AddChoreViewController.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/26/21.
//

import UIKit

class AddChoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Dependency Injection: required to access HomeViewCOntroller methods and vars
    private let home: HomeViewController
    init(home: HomeViewController) {
        self.home = home
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // User input: Chore title definition
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
    
    // User input: Points definition
    private let pointsField: UITextField = {
        let field = UITextField()
        field.placeholder = "Points..."
        field.returnKeyType = .next
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8.0
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    // User input: Assigned user picker definition
    private let userPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .secondarySystemBackground
        picker.layer.borderWidth = 0.5
        picker.layer.cornerRadius = 8.0
        picker.tintColor = .blue
        return picker
    }()
    
    private let userPickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Assign to:"
        return label
    }()
    
    var usersDict: [String:User] = { () -> [String:User] in
        var userDict = [:] as [String:User]
        for user in choresList.users.value! {
            userDict[user.name!] = user
        }
        return userDict
    }()
    
    var usersList: [String] = { () -> [String] in
        var userNames = [] as [String]
        for user in choresList.users.value! {
            userNames.append(user.name!)
        }
        return userNames
    }()
    
    var selectedUser = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usersList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usersList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedUser = usersList[row]
        print(self.selectedUser)
    }
    
    // Submit button definition
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
        
        // Picker view initializations
        userPicker.delegate = self
        userPicker.dataSource = self
        selectedUser = usersList[0]
        
        // Add subviews
        view.addSubview(titleField)
        view.addSubview(pointsField)
        view.addSubview(userPickerLabel)
        view.addSubview(userPicker)
        view.addSubview(submitButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Position frames
        titleField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+10, width: view.frame.size.width-40, height: 52)
        pointsField.frame = CGRect(x: 20, y: titleField.frame.maxY+10, width: view.frame.size.width-40, height: 52)
        userPickerLabel.frame = CGRect(x: 20, y: pointsField.frame.maxY+15, width: view.frame.size.width-40, height: 20)
        userPicker.frame = CGRect(x: 20, y: userPickerLabel.frame.maxY+10, width: view.frame.size.width-40, height: 100)
        submitButton.frame = CGRect(x: 20, y: userPicker.frame.maxY+10, width: view.frame.size.width-40, height: 52)
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
        print("\n-- NEW CHORE --")
        print("Title: ", title)
        print("Points: ", points)
        print("Assigned to: ", usersDict[selectedUser] ?? User(name: "ERROR", points: 0, pictureURL: "https://media-exp1.licdn.com/dms/image/C4E03AQG1K38VePz-kQ/profile-displayphoto-shrink_200_200/0/1565002151065?e=1623888000&v=beta&t=GmmqAF4sHLeT020QAoNqwRcREIRS_x22xzNOIjiGQo"))
        
        // Process data, create new chore from input
        let chore = Chore(partition: "part",
                          title: title,
                          createdBy: User(name: "Joe Delle Donne", points: 0, pictureURL: "https://media-exp1.licdn.com/dms/image/C4E03AQG1K38VePz-kQ/profile-displayphoto-shrink_200_200/0/1565002151065?e=1623888000&v=beta&t=GmmqAF4sHLeT020QAoNqwRcREIRS_x22xzNOIjiGQo"),
                          assignedTo: usersDict[selectedUser] ?? User(name: "ERROR", points: 0, pictureURL: "https://media-exp1.licdn.com/dms/image/C4E03AQG1K38VePz-kQ/profile-displayphoto-shrink_200_200/0/1565002151065?e=1623888000&v=beta&t=GmmqAF4sHLeT020QAoNqwRcREIRS_x22xzNOIjiGQo"),
                          dueDate: Date(),
                          repeating: false,
                          points: Int(points) ?? 0,
                          status: "incomplete")
        choresList.chores.value!.append(chore)
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
