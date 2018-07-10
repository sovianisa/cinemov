//
//  SimilarMovieFlowLayout.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 11/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//

import UIKit

class SimilarMovieFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 3
            
            let itemWidth = (((self.collectionView!.frame.width) - (numberOfColumns - 1)) / numberOfColumns) - 10
            return CGSize(width: itemWidth, height:itemWidth+(itemWidth/2))
        }
    }
    
    
    
    func setupLayout() {
        sectionInset =  UIEdgeInsetsMake(0, 5, 0, 5)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 10
        scrollDirection = .horizontal
    }
}

