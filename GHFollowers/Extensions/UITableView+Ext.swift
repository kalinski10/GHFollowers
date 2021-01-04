//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 11/12/2020.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() { // common extension for removing cells
        tableFooterView = UIView(frame: .zero)
    }
    
    
    func reloadDataOnMainThread() { // another common extension for reloading data on main thread
        DispatchQueue.main.async { self.reloadData() }
    }
}
