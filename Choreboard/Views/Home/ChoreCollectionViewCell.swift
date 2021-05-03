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
            y: titleLabel.frame.minY + 20,
            width: 300,
            height: titleLabel.frame.height
        )
        
        pointsLabel.frame = CGRect(
            x: assignedToLabel.frame.minX,
            y: assignedToLabel.frame.minY + 20,
            width: 300,
            height: titleLabel.frame.height
        )
        
        creationDateLabel.frame = CGRect(
            x: pointsLabel.frame.minX,
            y: pointsLabel.frame.minY + 20,
            width: 300,
            height: titleLabel.frame.height
        )
        
        statusLabel.frame = CGRect(
            x: creationDateLabel.frame.minX,
            y: creationDateLabel.frame.minY + 25,
            width: 100,
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
        assignedToLabel.text = "Assigned to: \(viewModel.assignedTo.name ?? "<nil>")"
        points = viewModel.points
        pointsLabel.text = "Points: \(String(viewModel.points))"
        creationDateLabel.text = "Date added: \(viewModel.creationDate.description.split(separator: " ")[0] + " " +  viewModel.creationDate.description.split(separator: " ")[1])"
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
