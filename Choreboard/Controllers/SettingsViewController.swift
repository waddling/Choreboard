//
//  SettingsViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/29/21.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userRealm: Realm
    let householdRealm: Realm
    
    var notificationToken: NotificationToken?
    var objectNotificationToken: NotificationToken?
    
    var userData: User?
    var houseData: Household?
    
    init(userRealm: Realm, householdRealm: Realm) {
        self.userRealm = userRealm
        self.householdRealm = householdRealm
        
        super.init(nibName: nil, bundle: nil)
        
        // There should only be one user in my realm - that is myself
        let usersInRealm = userRealm.objects(User.self)
        let householdsInRealm = householdRealm.objects(Household.self)

        notificationToken = usersInRealm.observe { [weak self, usersInRealm] (_) in
            self?.userData = usersInRealm.first
            self?.houseData = householdsInRealm.first
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        // Add view to controller
        view.addSubview(tableView)
        configureModels()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureModels() {
        sections.append(Section(title: "Profiles",
                                options: [
            Option(title: "My User Page", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewUserPage()
                }
            }), Option(title: "Household", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewHousehold()
                }
            })
        ]))
        
        sections.append(Section(title: "Account",
                                options: [
            Option(title: "Privacy", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewPrivacy()
                }
            }), Option(title: "Sign Out", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.signOutTapped()
                }
            })
        ]))
    }
    
    private func viewUserPage() {
        let vc = UserPageViewController(userData: userData!, houseData: houseData!)
        vc.title = "User Page"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func viewHousehold() {
        let vc = HouseholdViewController()
        vc.title = "Household"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped() {
        // Sign out
    }
    
    private func viewPrivacy() {
        let vc = PrivacyViewController()
        vc.title = "Privacy"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableVieew: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    // When user taps on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Call handler for cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
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
