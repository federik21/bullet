//
//  PatternCellItem.swift
//  Bullet
//
//  Created by federico piccirilli on 24/11/2021.
//

import UIKit

class PatternCellItem: UICollectionViewCell {
    static let nibName = "PatternCellItem"
    
    let patterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "Profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
