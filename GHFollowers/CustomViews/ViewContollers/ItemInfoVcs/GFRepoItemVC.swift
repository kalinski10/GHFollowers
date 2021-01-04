//
//  GFPublicReposVC.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 07/12/2020.
//

import Foundation

protocol GFRepoItemVCDelegate: AnyObject {
    func getProfileTapped(user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate!
    
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    
    func configureVC() {
        itemViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Get Profile")
    }
    
    
    override func actionButtonTapped() {
        delegate.getProfileTapped(user: user)
    }
}
