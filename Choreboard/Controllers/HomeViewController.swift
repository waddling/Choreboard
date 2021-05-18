//
//  HomeViewController.swift
//  Choreboard
//
//  Created by Yeon Jun Kim on 3/24/21.
//

import UIKit
import RealmSwift

// Observable
class Observable<T> {
    var value: T? {
        didSet {
            listeners.forEach {
                $0(value)
            }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?) -> Void)] = []
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
}

struct ChoreListViewModel {
    var chores: Observable<[Chore]> = Observable([])
    var users: Observable<[Member]> = Observable([])
}

enum HomeSectionType {
    case chores(viewModels: [ChoreCellViewModel])                       // 0
    case householdMembers(viewModels: [HouseholdMemberCellViewModel])   // 1
    
    var title: String {
        switch self {
        case .chores:
            return "Household Chores"
        case .householdMembers:
            return "Household members (tap for summary)"
        }
    }
}

var choresList = ChoreListViewModel()

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [HomeSectionType]()
    func reloadSections() {
        sections = [HomeSectionType]()
        sections.append(.chores(viewModels: choresList.chores.value!.compactMap({
            return ChoreCellViewModel(
                title: $0.title,
                assignedTo: $0.assignedTo ?? Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://media-exp1.licdn.com/dms/image/C4E03AQG1K38VePz-kQ/profile-displayphoto-shrink_200_200/0/1565002151065?e=1623888000&v=beta&t=GmmqAF4sHLeT020QAoNqwRcREIRS_x22xzNOIjiGQo"),
                creationDate: $0.creationDate,
                status: $0.status,
                points: $0.points
            )
        })))
        sections.append(.householdMembers(viewModels: choresList.users.value!.compactMap({
            return HouseholdMemberCellViewModel(
                name: $0.name!,
                points: $0.points,
                pictureURL: $0.pictureURL!,
                user: $0
            )
        })))
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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

        // Populate dummy chore data
        choresList.chores.value!.append(Chore(partition: "part", title: "Do dishes", createdBy: Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), assignedTo: Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), dueDate: Date(), repeating: false, points: 1, status: "complete"))
        choresList.chores.value!.append(Chore(partition: "part", title: "Take trash out", createdBy: Member(name: "Yeon Kim", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), assignedTo: Member(name: "John Holland", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), dueDate: Date(), repeating: false, points: 2, status: "incomplete"))
        choresList.chores.value!.append(Chore(partition: "part", title: "Do dishes", createdBy: Member(name: "TJ Silva", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), assignedTo: Member(name: "Yeon Kim", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), dueDate: Date(), repeating: false, points: 5, status: "incomplete"))
        choresList.chores.value!.append(Chore(partition: "part", title: "Do dishes again", createdBy: Member(name: "TJ Silva", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), assignedTo: Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), dueDate: Date(), repeating: false, points: 15, status: "complete"))
        choresList.chores.value!.append(Chore(partition: "part", title: "Sweep floor", createdBy: Member(name: "John Holland", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), assignedTo: Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), dueDate: Date(), repeating: false, points: 8, status: "incomplete"))
        choresList.chores.value!.append(Chore(partition: "part", title: "Make dinner", createdBy: Member(name: "Liam Karr", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), assignedTo: Member(name: "Liam Karr", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"), dueDate: Date(), repeating: false, points: 4, status: "incomplete"))
        
        // Populate dummy household members data
        choresList.users.value!.append(Member(name: "Joe Delle Donne", points: 5, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"))
        choresList.users.value!.append(Member(name: "Yeon Kim", points: 13, pictureURL: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/smartest-dog-breeds-1553287693.jpg?crop=0.673xw:1.00xh;0.167xw,0&resize=640:*"))
        choresList.users.value!.append(Member(name: "TJ Silva", points: 40, pictureURL: "https://media.nature.com/lw800/magazine-assets/d41586-020-03053-2/d41586-020-03053-2_18533904.jpg"))
        choresList.users.value!.append(Member(name: "John Holland", points: 6, pictureURL: "https://moderndogmagazine.com/sites/default/files/styles/slidehsow-banner/public/images/articles/top_images/Header_206.jpg?itok=4ttMMleH"))
        choresList.users.value!.append(Member(name: "Liam Karr", points: 24, pictureURL: "https://i.natgeofe.com/n/dd400a8b-4632-4076-af34-ec2c0a302a34/01-waq-dogs-and-storms-NationalGeographic_1468936.jpg"))
        
        // put dummy data into sections
        sections.append(.chores(viewModels: choresList.chores.value!.compactMap({
            return ChoreCellViewModel(
                title: $0.title,
                assignedTo: $0.assignedTo ?? Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"),
                creationDate: $0.creationDate,
                status: $0.status,
                points: $0.points
            )
        })))
        sections.append(.householdMembers(viewModels: choresList.users.value!.compactMap({
            return HouseholdMemberCellViewModel(
                name: $0.name ?? "John Doe",
                points: $0.points,
                pictureURL: $0.pictureURL!,
                user: $0
            )
        })))
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Home"
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
    
    func loadData() {
        // TODO: code to load data from database 
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        // register custom cells
        collectionView.register(ChoreCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChoreCollectionViewCell.identifier)
        collectionView.register(HouseholdMemberCollectionViewCell.self,
                                forCellWithReuseIdentifier: HouseholdMemberCollectionViewCell.identifier)
        
        // register headers and footers
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: TitleFooterCollectionReusableView.identifier
        )
        
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
            ),
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(85)
                ),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
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
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(300)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(300)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: TitleFooterCollectionReusableView.identifier,
                for: indexPath
            )
            // Add Chore button, Only do this footer for the first section
            if (indexPath.section == 0) {
                let plusImage = UIImage(systemName: "plus.app")
                let addButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
                addButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                addButton.backgroundColor = color.UIColorFromRGB(rgbValue: 0xd4d294)
                addButton.setImage(plusImage, for: .normal)
                addButton.frame = CGRect(x: 2, y: 15, width: 200, height: 65)
                addButton.setTitle("  Add Chore", for: .normal)
                addButton.setTitleColor(.black, for: .normal)
                addButton.tintColor = .black
                addButton.layer.cornerRadius = 8.0
                footer.addSubview(addButton)
                return footer
            }
            return footer
        }
        
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
    
    @objc func buttonAction() {
        print("Button pressed")
        let vc = AddChoreViewController(home: self)
        vc.title = "Add Chore"
        vc.navigationItem.largeTitleDisplayMode = .never
        //navigationController?.pushViewController(vc, animated: true)
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .chores(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ChoreCollectionViewCell.identifier, for: indexPath) as? ChoreCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.backgroundColor = color.UIColorFromRGB(rgbValue: 0x6EADE9)
            cell.configure(with: viewModel)
            cell.layer.cornerRadius = 8.0
            return cell
        case .householdMembers(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HouseholdMemberCollectionViewCell.identifier, for: indexPath) as? HouseholdMemberCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.backgroundColor = color.UIColorFromRGB(rgbValue: 0xB3D6C6)
            cell.configure(with: viewModel)
            cell.layer.cornerRadius = 8.0
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .chores(_):
            if let cell = collectionView.cellForItem(at: indexPath) as? ChoreCollectionViewCell {
                ()
            }
        case .householdMembers(_):
            if let cell = collectionView.cellForItem(at: indexPath) as? HouseholdMemberCollectionViewCell {
                print("Home: member tapped...")
                print(cell.user)
                let vc = MemberSummaryViewController(user: cell.user)
                vc.title = "Member Summary"
                vc.navigationItem.largeTitleDisplayMode = .never
                //navigationController?.pushViewController(vc, animated: true)
                present(UINavigationController(rootViewController: vc), animated: true)
                //reloadSections()
                // YEON TODO: Send updated data to database
            }
        }
    }
    
}
