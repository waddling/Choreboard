//
//  ProfileChoreCollectionViewCell.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/26/21.
//

import UIKit
import SDWebImage

class ProfileChoreCollectionViewCell: UICollectionViewCell {
    // set custom identifier
    static let identifier = "ProfileChoreCollectionViewCell"
    var checked = false
    var globalIndex = 0
    var user: Member = Member(name: "<temp>", points: 0, pictureURL: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
    
    // for a picture example, see 25:45 of part 9 of the tutorial
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let assignedToLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.square")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Overridden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(assignedToLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(checkboxImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        assignedToLabel.sizeToFit()
        pointsLabel.sizeToFit()
        creationDateLabel.sizeToFit()
        statusLabel.sizeToFit()
        checkboxImageView.sizeToFit()
        
        titleLabel.frame = CGRect(
            x: contentView.frame.minX + 7,
            y: contentView.frame.minY + 3,
            width: 300,
            height: titleLabel.frame.height
        )
        
        assignedToLabel.frame = CGRect(
            x: titleLabel.frame.minX,
            y: titleLabel.frame.minY + 29,
            width: 310,
            height: titleLabel.frame.height
        )
        
        creationDateLabel.frame = CGRect(
            x: assignedToLabel.frame.minX,
            y: assignedToLabel.frame.minY + 27,
            width: 310,
            height: titleLabel.frame.height
        )
        
        statusLabel.frame = CGRect(
            x: creationDateLabel.frame.minX + 45,
            y: creationDateLabel.frame.minY + 28,
            width: 100,
            height: titleLabel.frame.height
        )
        
        pointsLabel.frame = CGRect(
            x: statusLabel.frame.maxX + 5,
            y: statusLabel.frame.minY,
            width: 100,
            height: titleLabel.frame.height
        )
        
        checkboxImageView.frame = CGRect(
            x: statusLabel.frame.minX - 35,
            y: statusLabel.frame.minY - 2,
            width: 30,
            height: 30
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        assignedToLabel.text = nil
        pointsLabel.text = nil
        creationDateLabel.text = nil
        statusLabel.text = nil
    }
    
    // Configure view model to view
    func configure(with viewModel: ChoreCellViewModel, index: Int) {
        if (viewModel.status == "incomplete") {
            checked = false
            checkboxImageView.image = UIImage(systemName: "square")
            backgroundColor = color.UIColorFromRGB(rgbValue: 0xE38686)
        } else {
            checked = true
            checkboxImageView.image = UIImage(systemName: "checkmark.square")
            backgroundColor = color.UIColorFromRGB(rgbValue: 0xB3D6C6)
        }
        
        user = viewModel.assignedTo
        
        titleLabel.text = viewModel.title
        /*assignedToLabel.text = "Assigned to: \(viewModel.assignedTo.name ?? "<nil>")"
        pointsLabel.text = "Points: \(String(viewModel.points))"
        creationDateLabel.text = "Date added: \(viewModel.creationDate.description.split(separator: " ")[0] + " " + viewModel.creationDate.description.split(separator: " ")[1])"
        statusLabel.text = "Status: \(viewModel.status)"*/
        
        // Assigned to label config
        assignedToLabel.text = "Assigned to: \(viewModel.assignedTo.name ?? "<nil>")"
        assignedToLabel.sizeToFit()
        assignedToLabel.layer.masksToBounds = true
        assignedToLabel.layer.cornerRadius = 8.0
        assignedToLabel.textAlignment = NSTextAlignment(.center)
        assignedToLabel.layer.borderWidth = 1
        assignedToLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xc1d5f5)
        
        // Points labeel config
        pointsLabel.text = "Points: \(String(viewModel.points))"
        pointsLabel.sizeToFit()
        pointsLabel.layer.masksToBounds = true
        pointsLabel.layer.cornerRadius = 8.0
        pointsLabel.textAlignment = NSTextAlignment(.center)
        pointsLabel.layer.borderWidth = 1
        pointsLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xd4d294)
        
        // Creation date label config
        creationDateLabel.text = "Added on \(viewModel.creationDate.description.split(separator: " ")[0])"
        creationDateLabel.sizeToFit()
        creationDateLabel.layer.masksToBounds = true
        creationDateLabel.layer.cornerRadius = 8.0
        creationDateLabel.textAlignment = NSTextAlignment(.center)
        creationDateLabel.layer.borderWidth = 1
        creationDateLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xc1d5f5)
        
        // Statis label config
        statusLabel.text = "\(viewModel.status)"
        statusLabel.sizeToFit()
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 8.0
        statusLabel.textAlignment = NSTextAlignment(.center)
        statusLabel.layer.borderWidth = 1
        if viewModel.status == "complete" {
            statusLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xB3D6C6)
        } else {
            statusLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xE38686)
        }
        self.globalIndex = index
    }
    
    func isTapped() {
        checked = !checked
        if (checked) {
            statusLabel.text = "Status: complete"
            checkboxImageView.image = UIImage(systemName: "checkmark.square")
            backgroundColor = color.UIColorFromRGB(rgbValue: 0xB3D6C6)
        } else {
            statusLabel.text = "Status: incomplete"
            checkboxImageView.image = UIImage(systemName: "square")
            backgroundColor = color.UIColorFromRGB(rgbValue: 0xE38686)
        }
    }
    
}
