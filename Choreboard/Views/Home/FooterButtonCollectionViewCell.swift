//
//  FooterButtonCollectionViewCell.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/26/21.
//

import UIKit

class FooterButtonCollectionReusableView: UICollectionReusableView {
    static let identifier = "FooterButtonCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 2, y: 15, width: 400, height: 30)
    }
    
    func configure(with title: String) {
        label.text = "hello"
    }
        
}
