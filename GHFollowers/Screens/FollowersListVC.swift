//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 23/11/2020.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {
    
    enum Section {
        case main
    }

// MARK: - Properties
    
    var username: String!
    var followers: [Follower]           = []
    var filteredFollowers: [Follower]   = []
    
    var page                            = 1
    var hasMoreFollowers                = true
    var isSearching                     = false
    var isLoadingMoreFollowers          = false
            
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
// MARK: - Initialisers
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureVC()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
// MARK: - Private functions
    
    func  configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true // more modern way of doing the titles // and looks much better
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "Search For Username"
        searchController.obscuresBackgroundDuringPresentation   = false // removes the slight tint on the collectoinView when searching
        navigationItem.searchController                         = searchController
    }
    
// MARK: - @objc Functions
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(username: username) { [weak self]result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result{
            case .success(let user):
                self.addUserToFavourites(user: user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
// MARK: - Network call
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(username: username, page: page) { [weak self] result in // weak self handles memory leak so that there arent any strong reefences to that class so the referrence count wont be 2
            guard let self = self else { return } // this is done because the rest of the selfs are optional so we need to safely unwrap them
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false } // checks of there are more followers in order to know if we can make anoether network call
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This User doesnt have any followers. Go follow them!"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        
        self.updateData(on: self.followers)
    }
    
    
    func addUserToFavourites(user: User) {
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistanceManager.updateWith(favourite: favourite, actionType: .add) { [weak self]error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully added this user to your favourites.", buttonTitle: "Hooray!")
                return
            }
            self.presentGFAlertOnMainThread(title: "something went worng", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
// MARK: - collectionView configureations
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.backgroundColor  = .systemBackground
        collectionView.delegate         = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

// MARK: - Extension

extension FollowersListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredFollowers : followers // if else statement
        let follower    = activeArray[indexPath.row]
        
        let destVC      = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true) 
    }
}


extension FollowersListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}


extension FollowersListVC: UserInfoVCDelegate {
    
    func requestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1

        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true) // brings the scroll view back to the top to the first item
        getFollowers(username: username, page: page)
    }
}
