//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 27/11/2020.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        let width                       = view.bounds.width
        let padding:            CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3
        
        let layout                      = UICollectionViewFlowLayout()
        layout.itemSize                 = CGSize(width: itemWidth, height: itemWidth + 40)
        layout.minimumInteritemSpacing  = minimumItemSpacing
        layout.sectionInset             = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding) // padding around the collectionView
        
        return layout
    }
}
