//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 09/12/2020.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen // adjust the tint color of the items in the tabBar
        self.viewControllers            = [searchNC(), favouritesListNC()]
    }
    
    
    func searchNC() -> UINavigationController {
        let searchVC        = SearchVC()
        searchVC.title      = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }

    
    func favouritesListNC() -> UINavigationController {
        let favouritesListVC        = FavouritesListVC()
        favouritesListVC.title      = "Favourites"
        favouritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favouritesListVC)
    }
}
