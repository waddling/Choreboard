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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let temp = User(name: "Joe Delle Donne")
        self.updateUI(with: temp)
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
    
    private func updateUI(with model: User) {
        tableView.isHidden = false
        
        // configure table models (strings to be displayed in rows, in order)
        models.append("Name: \(model.name)")
        models.append("User ID: ")
        models.append("Household Name: ")
        models.append("Household ID: ")
        createTableHeader(with: "https://media-exp1.licdn.com/dms/image/C4E03AQG1K38VePz-kQ/profile-displayphoto-shrink_200_200/0/1565002151065?e=1623888000&v=beta&t=GmmqAF4sHLeT020QAoNqwRcREIRS_x22xzNOIjiwGQo")
        
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
