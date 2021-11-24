//
//  PatternView.swift
//  Bullet
//
//  Created by federico piccirilli on 24/11/2021.
//

import UIKit

class PatternsView: UIView {
    
    var patterns: [PatternViewModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        var myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: PatternCellItem.nibName)
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return myCollectionView
    }()
    
    func setUpView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension PatternsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return patterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: PatternCellItem.nibName, for: indexPath)
        myCell.backgroundColor = UIColor.blue
        return myCell
    }
    
    
}
