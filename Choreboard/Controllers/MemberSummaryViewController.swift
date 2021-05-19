//
//  MemberSummaryViewController.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 5/2/21.
//

import UIKit

enum MemberSummarySectionType {
    case chores(viewModels: [ChoreCellViewModel])
}

class MemberSummaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        //image.sd_setImage(with: url, completed: nil)
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "<title>"
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8.0
        label.textAlignment = NSTextAlignment(.center)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = color.UIColorFromRGB(rgbValue: 0x6EADE9)
        label.layer.borderWidth = 1
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "<points>"
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8.0
        label.textAlignment = NSTextAlignment(.center)
        label.backgroundColor = color.UIColorFromRGB(rgbValue: 0xd4d294)
        label.layer.borderWidth = 1
        return label
    }()
    
    private let choresLabel: UILabel = {
        let label = UILabel()
        label.text = "Assigned chores:"
        return label
    }()
    
    // Define collection view objects
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return MemberSummaryViewController.createSectionLayout(section: sectionIndex)
        }
    )
    private var sections = [MemberSummarySectionType]()
    
    // Get user for the summary
    let user: Member
    init(user: Member) {
        self.user = user
        let url = URL(string: user.pictureURL ?? "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
        imageView.sd_setImage(with: url, completed: nil)
        self.titleLabel.text = user.name
        self.pointsLabel.text = "Points: \(String(user.points))"
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        // Get list of chores assigned to user
        var chores: [ChoreCellViewModel] = []
        for chore in choresList.chores.value! {
            if (chore.assignedTo?.name == user.name) {
                chores.append(ChoreCellViewModel(
                    title: chore.title,
                    assignedTo: chore.assignedTo ?? Member(name: "Joe Delle Donne", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg"),
                    creationDate: chore.creationDate,
                    status: chore.status,
                    points: chore.points
                ))
            }
        }
        sections.append(.chores(viewModels: chores))
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        // Order here matters! add subviews after collection views (?)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(pointsLabel)
        view.addSubview(choresLabel)
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 150
        imageView.frame = CGRect(
            x: view.frame.midX - imageSize/2,
            y: view.safeAreaInsets.top + 15,
            width: imageSize,
            height: imageSize
        )
        imageView.layer.cornerRadius = imageSize/2
        titleLabel.frame = CGRect(
            x: 20,
            y: imageView.frame.maxY + 5,
            width: view.frame.size.width-40,
            height: 30
        )
        print(titleLabel.frame)
        pointsLabel.frame = CGRect(
            x: 20,
            y: titleLabel.frame.maxY + 5,
            width: view.frame.size.width-40,
            height: 30
        )
        print(pointsLabel.frame)
        choresLabel.frame = CGRect(
            x: 20,
            y: pointsLabel.frame.maxY + 5,
            width: view.frame.size.width-40,
            height: 30
        )
        print(choresLabel.frame)
        collectionView.frame = CGRect(
            x: view.bounds.minX,
            y: choresLabel.frame.maxY + 5,
            width: view.bounds.width,
            height: view.bounds.height
        )
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        // register custom cells
        collectionView.register(ChoreCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChoreCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
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
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(360)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 30)
            section.orthogonalScrollingBehavior = .groupPaging  // .continuous (if single group)
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

extension MemberSummaryViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .chores(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
            cell.layer.cornerRadius = 8.0
            cell.configure(with: viewModel)
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
        }
    }
    
}
