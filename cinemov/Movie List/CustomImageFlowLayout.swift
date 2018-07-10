//
//  CustomImageFlowLayout.swift
//  cinemov
//
//  Created by Annisa Sofia Noviantina on 10/07/18.
//  Copyright © 2018 Annisa Sofia Noviantina. All rights reserved.
//
import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {
    
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
            let numberOfColumns: CGFloat = 2
            
            let itemWidth = (((self.collectionView!.frame.width) - (numberOfColumns - 1)) / numberOfColumns) - 15
            return CGSize(width: itemWidth, height:itemWidth+(itemWidth/2))
        }
    }
    
    func setupLayout() {
        sectionInset =  UIEdgeInsetsMake(0, 10, 0, 10)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 10
        scrollDirection = .vertical
    }
    
}


