//
//  HouseholdMemberCollectionViewCell.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/13/21.
//

import UIKit

class HouseholdMemberCollectionViewCell: UICollectionViewCell {
    static let identifier = "HouseholdMemberCollectionViewCell"
    
    var user: User = User(name: "<temp>", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
    
    // for a picture example, see 25:45 of part 9 of the tutorial
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageSize: CGFloat = 50
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = imageSize/2
        //image.sd_setImage(with: url, completed: nil)
        return image
    }()
    
    // Overridden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        //contentView.addSubview(pointsLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        pointsLabel.sizeToFit()
        
        
        imageView.frame = CGRect(
            x: contentView.frame.minX + 50,
            y: contentView.frame.minY + 15,
            width: imageView.frame.width,
            height: imageView.frame.height
        )
        
        nameLabel.center = contentView.center
        nameLabel.frame = CGRect(
            x: nameLabel.frame.minX,
            y: nameLabel.frame.minY + 20,
            width: nameLabel.frame.width,
            height: nameLabel.frame.height
        )
        //nameLabel.textAlignment = NSTextAlignment(.center)
        
        /*pointsLabel.frame = CGRect(
            x: nameLabel.frame.minX,
            y: nameLabel.frame.minY + 30,
            width: 150,
            height: nameLabel.frame.height
        )*/
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        pointsLabel.text = nil
    }
    
    // Configure view model to view
    func configure(with viewModel: HouseholdMemberCellViewModel) {
        user = viewModel.user
        nameLabel.text = viewModel.name
        nameLabel.textAlignment = NSTextAlignment(.center)
        pointsLabel.text = "Points: \(String(viewModel.points))"
        pointsLabel.layer.masksToBounds = true
        pointsLabel.layer.cornerRadius = 8.0
        pointsLabel.textAlignment = NSTextAlignment(.center)
        pointsLabel.layer.borderWidth = 1
        pointsLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xd4d294)
        let url = URL(string: viewModel.pictureURL)
        imageView.sd_setImage(with: url, completed: nil)
    }
    
}
