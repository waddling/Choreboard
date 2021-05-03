//
//  ProfileViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/24/21.
//

import UIKit
import RealmSwift

enum ProfileSectionType {
    case chores(viewModels: [ChoreCellViewModel])                       // 0
    case householdMembers(viewModels: [ProfileHouseholdMemberCellViewModel])   // 1
    
    var title: String {
        switch self {
        case .chores:
            return "My Chores (Tap to toggle complete)"
        case .householdMembers:
            return "My Household"
        }
    }
}

class color:NSObject
{
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class ProfileViewController: UIViewController {
    
    var globalIndexes: [Int] = []
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return ProfileViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [ProfileSectionType]()
    
    func reloadSections() {
        var myChores: [Chore] = { () -> [Chore] in
            self.globalIndexes = []
            var chores = [] as [Chore]
            for (index, chore) in choresList.chores.value!.enumerated() {
                if chore.assignedTo?.name == "Joe Delle Donne" {
                    chores.append(chore)
                    self.globalIndexes.append(index)
                }
            }
            return chores
        }()
        sections = [ProfileSectionType]()
        sections.append(.chores(viewModels: myChores.compactMap({
            return ChoreCellViewModel(
                title: $0.title,
                assignedTo: $0.assignedTo ?? Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"),
                creationDate: $0.creationDate,
                status: $0.status,
                points: $0.points
            )
        })))
        sections.append(.householdMembers(viewModels: choresList.users.value!.compactMap({
            return ProfileHouseholdMemberCellViewModel(
                name: $0.name!,
                points: $0.points,
                pictureURL: $0.pictureURL!,
                user: $0
            )
        })))
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        // Listen to choresList ViewModel, reload whenever something changes
        choresList.chores.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadSections()
            }
        }
        choresList.users.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadSections()
            }
        }
        
        // Put dummy data into sections
        var myChores: [Chore] = { () -> [Chore] in
            self.globalIndexes = []
            var chores = [] as [Chore]
            for (index, chore) in choresList.chores.value!.enumerated() {
                if chore.assignedTo?.name == "Joe Delle Donne" {
                    chores.append(chore)
                    self.globalIndexes.append(index)
                }
            }
            return chores
        }()
        sections.append(.chores(viewModels: myChores.compactMap({
            return ChoreCellViewModel(
                title: $0.title,
                assignedTo: $0.assignedTo ?? Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"),
                creationDate: $0.creationDate,
                status: $0.status,
                points: $0.points
            )
        })))
        sections.append(.householdMembers(viewModels: choresList.users.value!.compactMap({
            return ProfileHouseholdMemberCellViewModel(
                name: $0.name!,
                points: $0.points,
                pictureURL: $0.pictureURL!,
                user: $0
            )
        })))
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        // Order here matters! add subviews after collection views
        configureCollectionView()
        view.addSubview(spinner)
        // fetch data goes here?
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        // register custom cells
        collectionView.register(ProfileChoreCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfileChoreCollectionViewCell.identifier)
        collectionView.register(ProfileHouseholdMemberCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfileHouseholdMemberCollectionViewCell.identifier)
        
        // register headers
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        
        collectionView.allowsSelection = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        // Section headers
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // group, scroll horizontally or vertically here
            // for all one group, use one group and change 'group' name in section declaration
            // vertical group inside of a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(480)
                ),
                subitem: item,
                count: 4
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(480)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 30)
            section.orthogonalScrollingBehavior = .groupPaging  // .continuous (if single group)
            return section
            
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            // group, scroll horizontally or vertically here
            // for all one group, use one group and change 'group' name in section declaration
            // vertical group inside of a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                ),
                subitem: item,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
            
        default:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 5)
            
            // group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(90)
                ),
                subitem: item,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .chores(let viewModels):
            return viewModels.count
        case .householdMembers(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .chores(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileChoreCollectionViewCell.identifier, for: indexPath) as? ProfileChoreCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            //cell.backgroundColor = color.UIColorFromRGB(rgbValue: 0x6EADE9)
            cell.configure(with: viewModel, index: self.globalIndexes[indexPath.row])
            cell.layer.cornerRadius = 8.0
            return cell
        case .householdMembers(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileHouseholdMemberCollectionViewCell.identifier, for: indexPath) as? ProfileHouseholdMemberCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.backgroundColor = color.UIColorFromRGB(rgbValue: 0x6EADE9)
            cell.configure(with: viewModel)
            cell.layer.cornerRadius = 8.0
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .chores(_):
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileChoreCollectionViewCell {
                // Change cell appearance
                cell.isTapped()
                //print("global: ", cell.globalIndex)
                
                // Alter points of user
                var index = 0
                for (i, user) in choresList.users.value!.enumerated() {
                    if (user.name == cell.user.name) {
                        index = i
                    }
                }
                
                if (!cell.checked) {
                    choresList.users.value![index].points -= choresList.chores.value![cell.globalIndex].points
                } else {
                    choresList.users.value![index].points += choresList.chores.value![cell.globalIndex].points
                }
                
                
                print(cell.user)
                // Alter tapped chore data
                if (!cell.checked) {
                    // Now incomplete, tapped while checked, make incomplete
                    choresList.chores.value![cell.globalIndex].status = "incomplete"
                    choresList.users.value!.append(Member(name: "<temp>", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"))
                    _ = choresList.users.value!.popLast()
                } else {
                    // Now complete, tapped while unchecked, make complete
                    choresList.chores.value![cell.globalIndex].status = "complete"
                    choresList.users.value!.append(Member(name: "<temp>", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"))
                    _ = choresList.users.value!.popLast()
                }
                reloadSections()
                // YEON TODO: Send updated data to database
            }
        case .householdMembers(_):
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileHouseholdMemberCollectionViewCell {
                print(cell.user)
                //reloadSections()
                // YEON TODO: Send updated data to database
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .chores(_):
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileChoreCollectionViewCell {
                //cell.contentView.backgroundColor = color.UIColorFromRGB(rgbValue: 0x6EADE9)
            }
        case .householdMembers(_):
            ()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .chores(_):
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = color.UIColorFromRGB(rgbValue: 0xB2B27A)
            }
        case .householdMembers(_):
            ()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .chores(_):
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = nil
            }
        case .householdMembers(_):
            ()
        }
    }
    
}
