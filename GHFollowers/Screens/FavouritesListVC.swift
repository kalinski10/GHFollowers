//
//  FavouritesVC.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 22/11/2020.
//

import UIKit

class FavouritesListVC: GFDataLoadingVC {
    
    let tableView   = UITableView()
    var favourites: [Follower] = []

// MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    

    func configureVC() {
        title                   = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

// MARK: - Private functions
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.removeExcessCells()
        
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }

    
    func getFavourites() {
        PersistanceManager.retrieveFavourites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favourites):
                self.updateUI(with: favourites)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func updateUI(with favourites: [Follower]) {
        if favourites.isEmpty {
            self.showEmptyStateView(with: "No favourites?\nAdd one on the follower screen", in: self.view)
        } else {
            self.favourites = favourites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

// MARK: - Extensions

extension FavouritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID) as! FavouriteCell
        let favourite   = favourites[indexPath.row]
        cell.set(favourite: favourite)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite   = favourites[indexPath.row]
        let destVC      = FollowersListVC(username: favourite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        PersistanceManager.updateWith(favourite: favourites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favourites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left) // adds animation as oppose to reload data
                return
            }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
