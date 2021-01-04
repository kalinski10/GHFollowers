//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 10/12/2020.
//

import UIKit

extension UIView {
    
    // this is a variadic parameter, give the ability to pass any number of subviews
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    
    func pinToEdges(of superview: UIView) { // another common extension to add pin a view to a subview
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
}
