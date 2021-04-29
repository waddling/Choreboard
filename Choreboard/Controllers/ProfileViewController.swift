//
//  ProfileViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/24/21.
//

import UIKit
import RealmSwift

enum ProfileSectionType {
    case chores(viewModels: [ProfileChoreCellViewModel])                       // 0
    case householdMembers(viewModels: [ProfileHouseholdMemberCellViewModel])   // 1
    
    var title: String {
        switch self {
        case .chores:
            return "My Chores"
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
    var choresList = [Chore]()
    
    override func viewDidLoad() {
        
        // Populate dummy data
        //var choresList = [Chore]()
        choresList.append(Chore(partition: "part", title: "Do dishes", createdBy: User(name: "Joe Delle Donne"), assignedTo: User(name: "Joe Delle Donne"), dueDate: Date(), repeating: false, points: 1, status: "complete"))
        choresList.append(Chore(partition: "part", title: "Take trash out", createdBy: User(name: "Yeon Kim"), assignedTo: User(name: "Joe Delle Donne"), dueDate: Date(), repeating: false, points: 2, status: "incomplete"))
        choresList.append(Chore(partition: "part", title: "Do dishes", createdBy: User(name: "TJ Silva"), assignedTo: User(name: "Joe Delle Donne"), dueDate: Date(), repeating: false, points: 3, status: "incomplete"))
        choresList.append(Chore(partition: "part", title: "Do dishes again", createdBy: User(name: "TJ Silva"), assignedTo: User(name: "Joe Delle Donne"), dueDate: Date(), repeating: false, points: 3, status: "complete"))
        choresList.append(Chore(partition: "part", title: "Sweep floor", createdBy: User(name: "John Holland"), assignedTo: User(name: "Joe Delle Donne"), dueDate: Date(), repeating: false, points: 3, status: "incomplete"))
        choresList.append(Chore(partition: "part", title: "Make dinner", createdBy: User(name: "Liam Karr"), assignedTo: User(name: "Joe Delle Donne"), dueDate: Date(), repeating: false, points: 3, status: "incomplete"))
        
        var usersList = [User]()
        usersList.append(User(name: "Joe Delle Donne"))
        usersList.append(User(name: "Yeon Kim"))
        usersList.append(User(name: "TJ Silva"))
        usersList.append(User(name: "John Holland"))
        usersList.append(User(name: "Liam Karr"))
        
        // put dummy data into sections
        sections.append(.chores(viewModels: choresList.compactMap({
            return ProfileChoreCellViewModel(
                title: $0.title,
                createdBy: $0.createdBy ?? User(name: "Joe Delle Donne"),
                creationDate: $0.creationDate,
                status: $0.status)
        })))
        sections.append(.householdMembers(viewModels: usersList.compactMap({
            return ProfileHouseholdMemberCellViewModel(
                name: $0.name!
            )
        })))
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        // Order here matters! add subviews after collection views
        configureCollectionView()
        view.addSubview(spinner)
        // fetch data goes here
        
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
            cell.configure(with: viewModel)
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
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .chores(_):
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileChoreCollectionViewCell {
                //cell.contentView.backgroundColor = color.UIColorFromRGB(rgbValue: 0xB2B27A)
                //choresList[indexPath.item].status = "yeet"
                cell.isTapped()
                //collectionView.reloadData()
                // TODO: Send updated data to database
            }
        case .householdMembers(_):
            ()
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
