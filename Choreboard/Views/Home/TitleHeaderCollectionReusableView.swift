//
//  TitleHeaderCollectionReusableView.swift
//  Choreboard
//
//  Created by Joseph Delle Donne on 4/13/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
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
        label.text = title
    }
        
}

class TitleFooterCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleFooterCollectionReusableView"
    
    private let addButton: UIButton = {
        let addButton = UIButton()
        return addButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(addButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addButton.frame = CGRect(x: 2, y: 15, width: 100, height: 30)
    }
    
    func configure(with title: String) {
        addButton.setTitle("Add Chore", for: .normal)
    }
        
}
