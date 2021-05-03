//
//  ProfileHouseholdMemberCollectionViewCell.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/26/21.
//

import UIKit

class ProfileHouseholdMemberCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileHouseholdMemberCollectionViewCell"
    
    var user: Member = Member(name: "<temp>", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
    
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
        contentView.addSubview(pointsLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        pointsLabel.sizeToFit()
        //nameLabel.center = contentView.center
        
        imageView.frame = CGRect(
            x: contentView.frame.minX + 15,
            y: contentView.frame.minY + 20,
            width: imageView.frame.width,
            height: imageView.frame.height
        )
        
        nameLabel.frame = CGRect(
            x: imageView.frame.minX + 75,
            y: imageView.frame.minY - 10,
            width: 300,
            height: 30
        )
        
        pointsLabel.frame = CGRect(
            x: nameLabel.frame.minX,
            y: nameLabel.frame.minY + 30,
            width: 150,
            height: nameLabel.frame.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        pointsLabel.text = nil
    }
    
    // Configure view model to view
    func configure(with viewModel: ProfileHouseholdMemberCellViewModel) {
        user = viewModel.user
        nameLabel.text = viewModel.name
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
