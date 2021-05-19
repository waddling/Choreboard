//
//  UserPageViewController.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/13/21.
//

import SDWebImage
import UIKit

class UserPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [String]()
    
    // Dependency Injection: required to access HomeViewCOntroller methods and vars
    private let userData: User
    private let houseData: Household
    init(userData: User, houseData: Household) {
        self.userData = userData
        self.houseData = houseData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let temp = Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
        self.updateUI(with: userData, model2: houseData)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Do any additional setup after loading the view.
        title = "User Page"
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func updateUI(with model: User, model2: Household) {
        tableView.isHidden = false
        
        // configure table models (strings to be displayed in rows, in order)
        models.append("Name: \(model.name ?? "<nil>")")
        models.append("User ID: \(model._id ?? "<nil>")")
        models.append("Household Name: \(model2.name ?? "<nil>")")
        models.append("Household ID: \(model2._id ?? "<nil>")")
        createTableHeader(with: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
        
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?) {
        // Convert string to usable URL
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        
        // Position picture on screen
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width/1.5))
        let imageSize: CGFloat = headerView.bounds.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        
        // Makes profile pic a circle
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
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
