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
    
    // Overridden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(assignedToLabel)
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
        creationDateLabel.sizeToFit()
        statusLabel.sizeToFit()
        
        assignedToLabel.frame = CGRect(
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
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        assignedToLabel.text = nil
        creationDateLabel.text = nil
        statusLabel.text = nil
    }
    
    // Configure view model to view
    func configure(with viewModel: ChoreCellViewModel) {
        titleLabel.text = viewModel.title
        assignedToLabel.text = "Assigned to: \(viewModel.assignedTo.name)"
        creationDateLabel.text = "Date added: \(viewModel.creationDate.description.split(separator: " ")[0] + " " + viewModel.creationDate.description.split(separator: " ")[1])"
        statusLabel.text = "Status: \(viewModel.status)"
    }
    
}
