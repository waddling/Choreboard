//
//  ProfileHouseholdMemberCollectionViewCell.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/26/21.
//

import UIKit

class ProfileHouseholdMemberCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileHouseholdMemberCollectionViewCell"
    
    // for a picture example, see 25:45 of part 9 of the tutorial
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // lets text wrap if it needs to
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    // Overridden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        nameLabel.center = contentView.center
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    // Configure view model to view
    func configure(with viewModel: ProfileHouseholdMemberCellViewModel) {
        nameLabel.text = viewModel.name
    }
    
}
