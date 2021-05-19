//
//  ChoreCollectionViewCell.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/13/21.
//

import UIKit
import SDWebImage

class ChoreCollectionViewCell: UICollectionViewCell {
    // set custom identifier
    static let identifier = "ChoreCollectionViewCell"
    var points = 0
    
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
        label.layer.cornerRadius = 8.0
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
        label.layer.cornerRadius = 8.0
        return label
    }()
    
    // Overridden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(assignedToLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(statusLabel)
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
            x: creationDateLabel.frame.minX,
            y: creationDateLabel.frame.minY + 27,
            width: 152,
            height: titleLabel.frame.height
        )
        
        pointsLabel.frame = CGRect(
            x: statusLabel.frame.maxX + 5,
            y: statusLabel.frame.minY,
            width: 152,
            height: titleLabel.frame.height
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
    func configure(with viewModel: ChoreCellViewModel) {
        titleLabel.text = viewModel.title
        
        // Assigned to label config
        assignedToLabel.text = "Assigned to: \(viewModel.assignedTo.name ?? "<nil>")"
        assignedToLabel.sizeToFit()
        assignedToLabel.layer.masksToBounds = true
        assignedToLabel.layer.cornerRadius = 8.0
        assignedToLabel.textAlignment = NSTextAlignment(.center)
        assignedToLabel.layer.borderWidth = 1
        assignedToLabel.backgroundColor = color.UIColorFromRGB(rgbValue: 0xc1d5f5)
        
        // Points labeel config
        points = viewModel.points
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
        
    }
    
}
