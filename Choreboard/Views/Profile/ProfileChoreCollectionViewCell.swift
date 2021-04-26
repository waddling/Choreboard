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
    
    // for a picture example, see 25:45 of part 9 of the tutorial
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let createdByLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // lets text wrap if it needs to
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
        contentView.addSubview(createdByLabel)
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
        createdByLabel.sizeToFit()
        creationDateLabel.sizeToFit()
        statusLabel.sizeToFit()
        checkboxImageView.sizeToFit()
        
        createdByLabel.frame = CGRect(
            x: titleLabel.frame.minX + 5,
            y: titleLabel.frame.minY + 20,
            width: 300,
            height: titleLabel.frame.height
        )
        
        creationDateLabel.frame = CGRect(
            x: titleLabel.frame.minX + 5,
            y: titleLabel.frame.minY + 40,
            width: 300,
            height: titleLabel.frame.height
        )
        
        statusLabel.frame = CGRect(
            x: titleLabel.frame.minX + 5,
            y: titleLabel.frame.minY + 60,
            width: 300,
            height: titleLabel.frame.height
        )
        
        checkboxImageView.frame = CGRect(
            x: titleLabel.frame.minX + 5,
            y: titleLabel.frame.minY + 80,
            width: 30,
            height: 30
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        createdByLabel.text = nil
        creationDateLabel.text = nil
        statusLabel.text = nil
    }
    
    // Configure view model to view
    func configure(with viewModel: ProfileChoreCellViewModel) {
        if (viewModel.status == "incomplete") {
            checked = false
            checkboxImageView.image = UIImage(systemName: "square")
            backgroundColor = color.UIColorFromRGB(rgbValue: 0xE38686)
        } else {
            checked = true
            checkboxImageView.image = UIImage(systemName: "checkmark.square")
            backgroundColor = color.UIColorFromRGB(rgbValue: 0xB3D6C6)
        }
        
        titleLabel.text = viewModel.title
        createdByLabel.text = "Created by: \(viewModel.createdBy.name)"
        creationDateLabel.text = "Date added: \(viewModel.creationDate.description)"
        statusLabel.text = "Status: \(viewModel.status)"
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
